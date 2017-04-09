USE `chefjeeves`;
SET FOREIGN_KEY_CHECKS=1;
SET SQL_SAFE_UPDATES = 0;

DROP TABLE IF EXISTS `AccountRecipe`;
DROP TABLE IF EXISTS `RecipeIngredient`;
DROP TABLE IF EXISTS `AccountIngredient`;
DROP TABLE IF EXISTS `Recipe`;
DROP TABLE IF EXISTS `tmpRecipe`;
DROP TABLE IF EXISTS `Measurement`;
DROP TABLE IF EXISTS `Account`;
DROP TABLE IF EXISTS `Ingredient`;

DROP PROCEDURE IF EXISTS `DeleteIngredient`;
DROP PROCEDURE IF EXISTS `EmailExists`;
DROP PROCEDURE IF EXISTS `GetAccountIngredients`;
DROP PROCEDURE IF EXISTS `GetRecipe`;
DROP PROCEDURE IF EXISTS `GetRecipeDetails`;
DROP PROCEDURE IF EXISTS `GetRecipes`;
DROP PROCEDURE IF EXISTS `GetSecurityQuestion`;
DROP PROCEDURE IF EXISTS `InsertUser`;
DROP PROCEDURE IF EXISTS `UpdatePassword`;
DROP PROCEDURE IF EXISTS `UsernameExists`;
DROP PROCEDURE IF EXISTS `VerifyPassword`;
DROP PROCEDURE IF EXISTS `VerifySecurityAnswer`;

CREATE TABLE `account` (
	`USERNAME` varchar(64) NOT NULL,
	`EMAIL` varchar(64) NOT NULL,
	`FULL_NAME` varchar(64) NOT NULL,
	`SECURITY_QUESTION` varchar(64) NOT NULL,
	`SECURITY_ANSWER` varchar(512) NOT NULL,
	`PASSCODE` varchar(512) NOT NULL,
	`SALT` float NOT NULL,
  PRIMARY KEY (`USERNAME`,`EMAIL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `Recipe` (
	`RECIPE_ID` int(11) NOT NULL AUTO_INCREMENT,
	`SUBMITTED_USERNAME` varchar(64) NOT NULL,
	`RECIPE_NAME` varchar(64) NOT NULL,
	`PREPARATION` text NOT NULL,
  PRIMARY KEY (`RECIPE_ID`),
  CONSTRAINT `Recipe_Submitted_Username` FOREIGN KEY (`SUBMITTED_USERNAME`) REFERENCES `Account` (`USERNAME`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `AccountRecipe` (
	`USERNAME` varchar(64) NOT NULL,
	`RECIPE_ID` int(11) NOT NULL,
	PRIMARY KEY (`USERNAME`,`RECIPE_ID`),
	CONSTRAINT `AccountRecipe_USERNAME` FOREIGN KEY (`USERNAME`) REFERENCES `Account` (`USERNAME`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `AccountRecipe_RECIPE_ID` FOREIGN KEY (`RECIPE_ID`) REFERENCES `Recipe` (`RECIPE_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `Ingredient` (
	`INGREDIENT_ID` int(11) NOT NULL,
	`INGREDIENT_NAME` varchar(64) NOT NULL,
	PRIMARY KEY (`INGREDIENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `Measurement` (
	`UNIT_ABBREVIATION` varchar(64) NOT NULL,
	`UNIT_NAME` varchar(64) NOT NULL,
	PRIMARY KEY (`UNIT_ABBREVIATION`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `RecipeIngredient` (
	`RECIPE_ID` int(11) NOT NULL,
	`INGREDIENT_ID` int(11) NOT NULL,
	`QUANTITY` float NOT NULL,
	`UNIT_ABBREVIATION` varchar(64) NOT NULL,
	PRIMARY KEY (`RECIPE_ID`,`INGREDIENT_ID`),
	CONSTRAINT `RecipeIngredient_RECIPE_ID` FOREIGN KEY (`RECIPE_ID`) REFERENCES `Recipe` (`RECIPE_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `RecipeIngredient_INGREDIENT_ID` FOREIGN KEY (`INGREDIENT_ID`) REFERENCES `Ingredient` (`INGREDIENT_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `RecipeIngredient_UNIT_ABBREVIATION` FOREIGN KEY (`UNIT_ABBREVIATION`) REFERENCES `Measurement` (`UNIT_ABBREVIATION`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `AccountIngredient` (
	`USERNAME` varchar(64) NOT NULL,
	`INGREDIENT_ID` int(11) NOT NULL,
	PRIMARY KEY (`USERNAME`,`INGREDIENT_ID`),
	CONSTRAINT `AccountIngredient_USERNAME` FOREIGN KEY (`USERNAME`) REFERENCES `Account` (`USERNAME`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `AccountIngredient_INGREDIENT_ID` FOREIGN KEY (`INGREDIENT_ID`) REFERENCES `Ingredient` (`INGREDIENT_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DELIMITER $$

CREATE PROCEDURE `DeleteIngredient`(
    IN User VARCHAR(64),
	IN ID int(11)
)
BEGIN
	DELETE FROM AccountIngredient WHERE Ingredient_ID = ID and username = User;
END$$

CREATE PROCEDURE `EmailExists`(
  IN Address VARCHAR(64),
  OUT Result tinyint(1)
)
BEGIN
  DECLARE vEmail VARCHAR(64);
  SET vEmail= (SELECT Email FROM account WHERE email = Address LIMIT 1);
  IF vEmail = Address THEN
    SET Result = 1;
  ELSE
    SET Result = 0;
  END IF;
END$$

CREATE PROCEDURE `GetAccountIngredients`(
  IN User VARCHAR(64),
  IN Ingredient VARCHAR(64)
)
BEGIN
  SELECT b.Ingredient_Name as NAME, b.Ingredient_ID as ID 
  FROM AccountIngredient a, Ingredient b
  WHERE a.Ingredient_ID = b.Ingredient_ID and a.username = User and b.INGREDIENT_NAME LIKE CONCAT(Ingredient,'%')
  ORDER BY b.Ingredient_Name;
END$$

CREATE PROCEDURE `GetRecipe`(
    IN ID int(11),
	OUT Name varchar(64),
    OUT Prep text
)
BEGIN
    SELECT RECIPE_NAME, PREPARATION
	INTO Name, Prep
	FROM recipe
	WHERE RECIPE_ID = ID
	LIMIT 1;
END$$

CREATE PROCEDURE `GetRecipeDetails`(
    IN ID int(11)
)
BEGIN
    SELECT DISTINCT b.Ingredient_ID as ID, b.Ingredient_Name as Ingredient, a.Quantity, c.Unit_Abbreviation as Unit, c.Unit_Name
	FROM RecipeIngredient a, Ingredient b, Measurement c
	WHERE a.Ingredient_ID = b.Ingredient_ID 
		and a.Unit_Abbreviation = c.Unit_Abbreviation
        and a.Recipe_ID = ID
	ORDER BY b.Ingredient_Name, a.Quantity, c.Unit_Abbreviation;
END$$

CREATE PROCEDURE `GetRecipes`(
  IN User VARCHAR(64),
  IN Recipe VARCHAR(64)
)
BEGIN
  DECLARE name varchar(64);
  DECLARE cntAccountIngredients, cntRecipeIngredients, idRecipe int(11);
  DECLARE done boolean DEFAULT FALSE;
  DECLARE cur CURSOR FOR SELECT Recipe_Name, Recipe_Id FROM Recipe;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  SET SQL_SAFE_UPDATES = 0;
  DROP TABLE IF EXISTS `tmpRecipe`;
  CREATE TEMPORARY TABLE `tmpRecipe` ENGINE=InnoDB DEFAULT CHARSET=utf8 AS SELECT Recipe_Name, Recipe_Id FROM Recipe;
  OPEN cur;
  rdloop: LOOP
    FETCH cur INTO name, idRecipe;
    IF done THEN
      LEAVE rdloop;
    END IF;
    SET cntAccountIngredients = (SELECT Count(c.Recipe_ID) as Count
	FROM AccountIngredient a, Ingredient b, Recipe c, RecipeIngredient d
	WHERE a.Ingredient_ID = b.Ingredient_ID
	and b.Ingredient_ID = d.Ingredient_ID
	and c.Recipe_ID = d.Recipe_ID
	and d.Recipe_ID = idRecipe
	and a.username = User);
	SET cntRecipeIngredients = (SELECT COUNT(c.Recipe_ID) as Count
	FROM Ingredient b, Recipe c, RecipeIngredient d
	WHERE b.Ingredient_ID = d.Ingredient_ID
	and c.Recipe_ID = d.Recipe_ID
	and c.Recipe_ID = idRecipe);
    IF cntAccountIngredients <> cntRecipeIngredients THEN
      DELETE FROM tmpRecipe WHERE Recipe_Id = idRecipe;
	END IF;
  END LOOP;
  CLOSE cur;
  SELECT Recipe_Name AS Name, Recipe_Id as ID FROM tmpRecipe WHERE Recipe_Name LIKE CONCAT(Recipe,'%') ORDER BY Recipe_Name;
END$$

CREATE PROCEDURE `GetSecurityQuestion`(
  IN User VARCHAR(64),
  OUT Question varchar(512)
)
BEGIN
  SELECT Security_Question
  INTO Question
  From account
  WHERE username = User;
END$$

CREATE PROCEDURE `InsertUser`(
	User varchar(64),
    Address varchar (64),
    FullName varchar(64),
    Pass varchar(512),
    Question varchar(512),
    Answer varchar(512)
)
BEGIN
	DECLARE vSalt FLOAT;
    SET vSalt = RAND();
    SET Pass = SHA2(CONCAT(Pass, vSalt),512);
    SET Answer = SHA2(CONCAT(Answer, vSalt),512);
    INSERT INTO `Account` VALUES (User, Address, FullName, Question, Answer, Pass, vSalt);
END$$

CREATE PROCEDURE `UpdatePassword`(
    IN User varchar(64),
	IN Pass varchar(512)
)
BEGIN
	DECLARE vSalt FLOAT;
    SET vSalt = RAND();
    SET Pass = SHA2(CONCAT(Pass, vSalt),512);
    UPDATE `Account` SET PASSCODE = Pass,SALT = vSalt 
	WHERE Username = User;
END$$

CREATE PROCEDURE `UsernameExists`(
  IN User VARCHAR(64),
  OUT Result tinyint(1)
)
BEGIN
  DECLARE vUserName VARCHAR(64);
  SET vUserName= (SELECT Username FROM account WHERE username = User LIMIT 1);
  IF vUserName = User THEN
    SET Result = 1;
  ELSE
    SET Result = 0;
  END IF;
END$$

CREATE PROCEDURE `VerifyPassword`(
  IN User VARCHAR(64),
  IN Pass VARCHAR(512),
  OUT IsSuccessful tinyint(1)
)
BEGIN
  DECLARE vSalt FLOAT;
  DECLARE vPassCode1 VARCHAR(512);
  DECLARE vPassCode2 VARCHAR(512);
  SET vSalt = (SELECT Salt FROM account WHERE username = user LIMIT 1);
  SET vPassCode1 = (SELECT Passcode FROM account WHERE username = user LIMIT 1);
  SET vPassCode2 = SHA2(CONCAT(Pass, vSalt),512);
  IF vPassCode1 = vPassCode2 THEN
    SET IsSuccessful = 1;
  ELSE
    SET IsSuccessful = 0;
  END IF;
END$$

CREATE PROCEDURE `VerifySecurityAnswer`(
  IN User VARCHAR(64),
  IN Answer VARCHAR(512),
  OUT IsSuccessful tinyint(1)
)
BEGIN
  DECLARE vSalt FLOAT;
  DECLARE vAnswer1 VARCHAR(512);
  DECLARE vAnswer2 VARCHAR(512);
  SET vSalt = (SELECT Salt FROM account WHERE username = user LIMIT 1);
  SET vAnswer1 = (SELECT Security_Answer FROM account WHERE username = user LIMIT 1);
  SET vAnswer2 = SHA2(CONCAT(Answer, vSalt),512);
  IF vAnswer1 = vAnswer2 THEN
    SET IsSuccessful = 1;
  ELSE
    SET IsSuccessful = 0;
  END IF;
END$$

CREATE PROCEDURE `GetAccountInfo`(
  IN User VARCHAR(64)
)
BEGIN
  SELECT Email, Full_Name, Security_Question, Security_Answer,Passcode 
  FROM Account a
  WHERE a.username = User;
END$$

'Sample password is *888uuu and security answer is 23 before hash and salt. An sanple image must reside in the Profiles folder names jsmith.jpg'
DELIMITER ;

INSERT INTO `account` (`USERNAME`,`EMAIL`,`FULL_NAME`,`SECURITY_QUESTION`,`SECURITY_ANSWER`,`PASSCODE`,`SALT`) VALUES ('jsmith','john.smith@email.com','John Smith','Age?','5ee521184a46f3bd25f08f60b922e3acc6c0ff60f219c102511b6f9c1aa0b05f606c4d93303030596b790cb402a06030b676a12e2460e0ff95fc5a0d1e3c8767','d064295332f4f5235f21bd8ad73941e810a81cdced996a35e7de7773fd35ef517f93589867d6ba4596604020a9a29110206c4f109dab3db5d64a260c34f0006b',0.999581);

INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (1,'bacon');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (2,'brown bean');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (3,'butter');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (4,'egg');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (5,'flour');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (6,'garlic');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (7,'milk');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (8,'olive oil');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (9,'orange');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (10,'black pepper');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (11,'salt');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (12,'strawberry');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (13,'tomato');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (14,'lettuce');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (15,'onion');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (16,'whole wheat bread');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (17,'cheddar cheese');

INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('', 'itself');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('tsp', 'teaspoon');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('tbsp', 'tablespoon');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('cup', 'cup');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('oz', 'ounce');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('fl.oz', 'fluid ounce');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('pt', 'pint');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('pinch', 'pinch');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('qt', 'quart');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('gal', 'gallon');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('lb', 'pound');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('doz', 'dozen');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('pkg', 'package');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('sm', 'small');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('med', 'medium');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('lg', 'large');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('sq', 'square');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('approx', 'approximately');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('min', 'minutes');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('slice', 'slice');
INSERT INTO MEASUREMENT(UNIT_ABBREVIATION, UNIT_NAME) VALUES ('strip', 'strip');

INSERT INTO RECIPE (RECIPE_ID, SUBMITTED_USERNAME, RECIPE_NAME, PREPARATION) 
VALUES (1, 'jsmith', 'Scrambled Eggs', 'BEAT eggs, milk, salt and black pepper in medium bowl until blended.
HEAT butter in large nonstick skillet over medium heat until hot. POUR IN egg mixture. As eggs begin to set, GENTLY PULL the eggs across the pan with a spatula, forming large soft curds.
CONTINUE cooking – pulling, lifting and folding eggs – until thickened and no visible liquid egg remains. Do not stir constantly. REMOVE from heat. SERVE immediately.');
INSERT INTO RECIPE (RECIPE_ID, SUBMITTED_USERNAME, RECIPE_NAME, PREPARATION)
VALUES (2, 'jsmith', 'BLTO Sandwich', 'Spread butter on 2 slice of whole wheat bread. Then assemble sandwich with 3 strips of bacon, a slice of lettuce, 2 slices of tomato, and 2 slices of onion.');
INSERT INTO RECIPE (RECIPE_ID, SUBMITTED_USERNAME, RECIPE_NAME, PREPARATION) 
VALUES (3, 'jsmith', 'Grilled Cheddar Cheese Sandwich', 'Put 3 slice of cheddar cheese inbetween 2 slice of whole wheat bread. Place on BBQ on each sandwich side until cheese melts.');

INSERT INTO accountrecipe(USERNAME, RECIPE_ID) VALUES ('jsmith', 1);
INSERT INTO accountrecipe(USERNAME, RECIPE_ID) VALUES ('jsmith', 2);
INSERT INTO accountrecipe(USERNAME, RECIPE_ID) VALUES ('jsmith', 3);

INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (1,4,4,'');
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (1,7,0.25,'cup');
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (1,11,1,'pinch');
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (1,10,1,'pinch');
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (1,3,4,'tsp');
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (2,16,2,'slice');
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (2,1,3,'strip');
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (2,14,1,'slice');
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (2,13,2,'slice');
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (2,15,2,'slice');
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (3,16,2,'slice');
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (3,17,3,'slice');

INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID) VALUES ('jsmith',1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID) VALUES ('jsmith',3);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID) VALUES ('jsmith',4);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID) VALUES ('jsmith',6);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID) VALUES ('jsmith',8);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID) VALUES ('jsmith',7);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID) VALUES ('jsmith',11);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID) VALUES ('jsmith',10);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID) VALUES ('jsmith',13);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID) VALUES ('jsmith',14);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID) VALUES ('jsmith',15);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID) VALUES ('jsmith',16);
