USE `chefjeeves`;
SET FOREIGN_KEY_CHECKS=1;
SET SQL_SAFE_UPDATES = 0;

DROP TABLE IF EXISTS `RecipeIngredient`;
DROP TABLE IF EXISTS `AccountIngredient`;
DROP TABLE IF EXISTS `Recipe`;
DROP TABLE IF EXISTS `tmpRecipe`;
DROP TABLE IF EXISTS `Measurement`;
DROP TABLE IF EXISTS `Account`;
DROP TABLE IF EXISTS `Ingredient`;

DROP PROCEDURE IF EXISTS `AddAllergen`;
DROP PROCEDURE IF EXISTS `AddIngredient`;
DROP PROCEDURE IF EXISTS `CreateAccount`;
DROP PROCEDURE IF EXISTS `CreateIngredient`;
DROP PROCEDURE IF EXISTS `DeleteAllergen`;
DROP PROCEDURE IF EXISTS `DeleteIngredient`;
DROP PROCEDURE IF EXISTS `EmailExists`;
DROP PROCEDURE IF EXISTS `GetAccount`;
DROP PROCEDURE IF EXISTS `GetAccountAllergens`;
DROP PROCEDURE IF EXISTS `GetAccountIngredients`;
DROP PROCEDURE IF EXISTS `GetNonAccountAllergens`;
DROP PROCEDURE IF EXISTS `GetNonAccountIngredients`;
DROP PROCEDURE IF EXISTS `GetRecipe`;
DROP PROCEDURE IF EXISTS `GetRecipeDetails`;
DROP PROCEDURE IF EXISTS `GetRecipes`;
DROP PROCEDURE IF EXISTS `GetSecurityQuestion`;
DROP PROCEDURE IF EXISTS `UpdateAccount`;
DROP PROCEDURE IF EXISTS `UpdateIngredientSearchability`;
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
	`RECIPE_NAME` varchar(64) NOT NULL,
	`PREPARATION` text NOT NULL,
  PRIMARY KEY (`RECIPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `Ingredient` (
	`INGREDIENT_ID` int(11) NOT NULL AUTO_INCREMENT,
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

CREATE PROCEDURE `AddIngredient`(
    IN User VARCHAR(64),
	IN ID int(11),
    OUT isSuccessful tinyint(1)
)
BEGIN
	IF (SELECT ID FROM AccountIngredient WHERE username = user AND ingredient_ID = ID LIMIT 1) is null THEN
		INSERT INTO `accountingredient` VALUES (User, ID);
        SET isSuccessful = 1;
    ELSE
		SET isSuccessful = 0;
    END IF;
END$$

CREATE PROCEDURE `CreateAccount`(
	User varchar(64),
    Address varchar (64),
    Name varchar(64),
    Pass varchar(512),
    Question varchar(512),
    Answer varchar(512)
)
BEGIN
	DECLARE Saltt FLOAT;
    SET Saltt = RAND();
    SET Pass = SHA2(CONCAT(Pass, Saltt), 512);
    SET Answer = SHA2(CONCAT(Answer, Saltt), 512);
    INSERT INTO `account` VALUES (User, Address, Name, Question, Answer, Pass, Saltt);
END$$

CREATE PROCEDURE `CreateIngredient`(
	IN Name VARCHAR(64),
	OUT ID INT(11)
)
BEGIN
	IF (SELECT Ingredient_id FROM Ingredient WHERE ingredient_name = Name LIMIT 1) is null THEN
		INSERT INTO `ingredient` (ingredient_name) VALUES (Name);
        SET ID = LAST_INSERT_ID();
    ELSE
		SET ID = 0;
    END IF;
END$$

CREATE PROCEDURE `DeleteIngredient`(
    IN User VARCHAR(64),
	IN ID int(11)
)
BEGIN
	DELETE FROM AccountIngredient WHERE Ingredient_ID = ID and username = User;
END$$

CREATE PROCEDURE `EmailExists`(
  IN User VARCHAR(64),
  IN Address VARCHAR(64),
  OUT Result tinyint(1)
)
BEGIN
  DECLARE currentUser VARCHAR(64);
  SET currentUser = (SELECT username FROM account WHERE email = Address LIMIT 1);
  IF currentUser is NULL THEN
    IF (SELECT email FROM account WHERE email = Address LIMIT 1) = Address THEN
		SET Result = 1;
	  ELSE
		SET Result = 0;
	  END IF;
  ELSE
    IF (SELECT email FROM account WHERE email = Address AND username != user LIMIT 1) = Address THEN
		SET Result = 1;
	  ELSE
		SET Result = 0;
	  END IF;
  END IF;
END$$

CREATE PROCEDURE `GetAccount`(
  IN User varchar(64),
  OUT Name varchar(64),
  OUT Address varchar(64),
  OUT Question varchar(64)
)
BEGIN
  SELECT FULL_NAME, EMAIL, SECURITY_QUESTION
    INTO Name, Address, Question
	FROM account
    WHERE Username = user
	LIMIT 1;
END$$

CREATE PROCEDURE `GetAccountIngredients`(
  IN User VARCHAR(64),
  IN Ingredient VARCHAR(64)
)
BEGIN
  SELECT b.Ingredient_Name as NAME, b.Ingredient_ID as ID, a.Is_Searchable as ISSEARCHABLE
  FROM AccountIngredient a, Ingredient b
  WHERE a.Ingredient_ID = b.Ingredient_ID and a.username = User and b.INGREDIENT_NAME LIKE CONCAT(Ingredient,'%')
  ORDER BY b.Ingredient_Name;
END$$

CREATE PROCEDURE `GetNonAccountIngredients`(
  IN User VARCHAR(64),
  IN Ingredient VARCHAR(64)
)
BEGIN
  SELECT Ingredient_Name as NAME, Ingredient_ID as ID 
  FROM Ingredient b
  WHERE Ingredient_Name LIKE CONCAT(Ingredient,'%') AND Ingredient_ID NOT IN 
  (SELECT b.Ingredient_ID as ID 
  FROM AccountIngredient a, Ingredient b
  WHERE a.Username = user
  and a.Ingredient_ID = b.Ingredient_ID
  and b.INGREDIENT_NAME LIKE CONCAT(Ingredient,'%'))
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

CREATE PROCEDURE `UpdateAccount`(
    IN User varchar(64),
	IN Name varchar(64),
	IN Address varchar(64),
    IN Question varchar(64),
	IN Answer varchar(512),
    IN Pass varchar(512)
)
BEGIN
	DECLARE Saltt FLOAT;
    SET Saltt = RAND();
    SET Pass = SHA2(CONCAT(Pass, Saltt), 512);
    SET Answer = SHA2(CONCAT(Answer, Saltt), 512); 
    UPDATE `account` 
	SET FULL_NAME = Name, EMAIL = Address, PASSCODE = Pass, SECURITY_QUESTION = Question, SECURITY_ANSWER = Answer, SALT = Saltt 
	WHERE Username = User;
END$$

CREATE PROCEDURE `UpdatePassword`(
    IN User varchar(64),
	IN Pass varchar(512)
)
BEGIN
	DECLARE Saltt FLOAT;
    SET Saltt = (SELECT SALT FROM account WHERE Username = user);
    SET Pass = SHA2(CONCAT(Pass, Saltt),512);
    UPDATE `Account` SET PASSCODE = Pass
	WHERE Username = User;
END$$

CREATE PROCEDURE `UsernameExists`(
  IN User VARCHAR(64),
  OUT Result tinyint(1)
)
BEGIN
  IF (SELECT Username FROM account WHERE username = User LIMIT 1) = User THEN
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
  DECLARE Saltt FLOAT;
  DECLARE PassCode1 VARCHAR(512);
  DECLARE PassCode2 VARCHAR(512);
  SET Saltt = (SELECT Salt FROM account WHERE username = user LIMIT 1);
  SET PassCode1 = (SELECT Passcode FROM account WHERE username = user LIMIT 1);
  SET PassCode2 = SHA2(CONCAT(Pass, Saltt),512);
  IF PassCode1 = PassCode2 THEN
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
  DECLARE Saltt FLOAT;
  DECLARE Answer1 VARCHAR(512);
  DECLARE Answer2 VARCHAR(512);
  SET Saltt = (SELECT Salt FROM account WHERE username = user LIMIT 1);
  SET Answer1 = (SELECT Security_Answer FROM account WHERE username = user LIMIT 1);
  SET Answer2 = SHA2(CONCAT(Answer, Saltt),512);
  IF Answer1 = Answer2 THEN
    SET IsSuccessful = 1;
  ELSE
    SET IsSuccessful = 0;
  END IF;
END$$

'Sample password is *888uuu and security answer is 23 before hash and salt. A sample image must reside in the Profiles folder names jsmith.jpg'
DELIMITER ;

INSERT INTO `account` (`USERNAME`,`EMAIL`,`FULL_NAME`,`SECURITY_QUESTION`,`SECURITY_ANSWER`,`PASSCODE`,`SALT`) VALUES ('jsmith','john.smith@email.com','John Smith','Age?','5ee521184a46f3bd25f08f60b922e3acc6c0ff60f219c102511b6f9c1aa0b05f606c4d93303030596b790cb402a06030b676a12e2460e0ff95fc5a0d1e3c8767','d064295332f4f5235f21bd8ad73941e810a81cdced996a35e7de7773fd35ef517f93589867d6ba4596604020a9a29110206c4f109dab3db5d64a260c34f0006b',0.999581);

INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (1,'bacon');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (2,'brown bean');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (3,'butter');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (4,'egg');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (5,'white flour');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (6,'garlic');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (7,'skim milk');
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
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (18,'green bean');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (19,'almond');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (20,'beet');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (21,'celery');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (22,'parsley');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (23,'lemon juice');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (24,'carrot');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (25,'pear');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (26,'ginger');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (27,'sugar');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (28,'whole wheat flour');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (29,'lemon');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (30,'almond milk');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (31,'cinnamon');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (32,'vegetable oil');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (33,'maple syrup');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (34,'soy sauce');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (35,'salmon');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (36,'brown sugar');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (37,'baking soda');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (38,'cola');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (39,'ketchup');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (40,'pork chop');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (41,'mayonaise');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (42,'paprika');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (43,'olive');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (44,'canned milk');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (45,'potato');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (46,'brown rice');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (47,'coconut oil');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (48,'water');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (49,'date');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (50,'raisin');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (51,'cashew nut');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (52,'cayenne pepper');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (53,'macaroni noodle');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (54,'spaghetti noodle');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (55,'parmesan cheese');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (56,'chicken broth');
INSERT INTO `ingredient`(`INGREDIENT_ID`,`INGREDIENT_NAME`) VALUES (57,'broccoli');

INSERT INTO `dietrestriction`(`DIET_RESTRICTION_ID`,`DIET_RESTRICTION_NAME`) VALUES (1,'nut allergy');
INSERT INTO `dietrestriction`(`DIET_RESTRICTION_ID`,`DIET_RESTRICTION_NAME`) VALUES (2,'lactose intolerant');
INSERT INTO `dietrestriction`(`DIET_RESTRICTION_ID`,`DIET_RESTRICTION_NAME`) VALUES (3,'celiac disease');

INSERT INTO `accountdietrestriction`(`USERNAME`,`DIET_RESTRICTION_ID`) VALUES ('jsmith',1);

INSERT INTO `dietrestrictioningredients`(DIET_RESTRICTION_ID,INGREDIENT_ID) VALUES (1,19);
INSERT INTO `dietrestrictioningredients`(DIET_RESTRICTION_ID,INGREDIENT_ID) VALUES (1,30);
INSERT INTO `dietrestrictioningredients`(DIET_RESTRICTION_ID,INGREDIENT_ID) VALUES (1,47);
INSERT INTO `dietrestrictioningredients`(DIET_RESTRICTION_ID,INGREDIENT_ID) VALUES (1,51);
INSERT INTO `dietrestrictioningredients`(DIET_RESTRICTION_ID,INGREDIENT_ID) VALUES (2,3);
INSERT INTO `dietrestrictioningredients`(DIET_RESTRICTION_ID,INGREDIENT_ID) VALUES (2,7);
INSERT INTO `dietrestrictioningredients`(DIET_RESTRICTION_ID,INGREDIENT_ID) VALUES (2,17);
INSERT INTO `dietrestrictioningredients`(DIET_RESTRICTION_ID,INGREDIENT_ID) VALUES (2,44);
INSERT INTO `dietrestrictioningredients`(DIET_RESTRICTION_ID,INGREDIENT_ID) VALUES (2,55);
INSERT INTO `dietrestrictioningredients`(DIET_RESTRICTION_ID,INGREDIENT_ID) VALUES (3,5);
INSERT INTO `dietrestrictioningredients`(DIET_RESTRICTION_ID,INGREDIENT_ID) VALUES (3,16);
INSERT INTO `dietrestrictioningredients`(DIET_RESTRICTION_ID,INGREDIENT_ID) VALUES (3,28);
INSERT INTO `dietrestrictioningredients`(DIET_RESTRICTION_ID,INGREDIENT_ID) VALUES (3,37);
INSERT INTO `dietrestrictioningredients`(DIET_RESTRICTION_ID,INGREDIENT_ID) VALUES (3,53);
INSERT INTO `dietrestrictioningredients`(DIET_RESTRICTION_ID,INGREDIENT_ID) VALUES (3,54);

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

INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (1, 'Scrambled Eggs ', 'BEAT eggs, milk, salt and black pepper in medium bowl until blended.\nHEAT butter in large nonstick skillet over medium heat until hot. POUR IN egg mixture. As eggs begin to set, GENTLY PULL the eggs across the pan with a spatula, forming large soft curds.\nCONTINUE cooking \u2013 pulling, lifting and folding eggs \u2013 until thickened and no visible liquid egg remains. Do not stir constantly. REMOVE from heat. SERVE immediately. ', 'good for the heart', 300);
INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (2, 'BLTO Sandwich ', 'Spread butter on 2 slice of whole wheat bread. Then assemble sandwich with 3 strips of bacon, a slice of lettuce, 2 slices of tomato, and 2 slices of onion. ', 'high carbs', 379);
INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (3, 'Grilled Cheddar Cheese Sandwich ', 'Put 3 slice of cheddar cheese inbetween 2 slice of whole wheat bread. Place on BBQ on each sandwich side until cheese melts. ', 'rich in calcium and protein', 380);
INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (4, 'Green Beans with Crushed Almonds ', 'Cook beans in a 3-qt. saucepan of boiling salted water until crisp-tender, about 4 minutes, and drain. Melt butter in a large nonstick skillet over moderate heat, then cook garlic, stirring, until it just begins to turn golden, about 1 minute. Add almonds and cook, stirring, until they begin to color slightly, about 2 minutes. Add beans and cook, stirring, until tender and heated through, about 2 minutes. Season with salt and pepper. ', 'high fiber content', 440);
INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (5, 'Veggie Detox ', 'Peel ginger and cut one 3/4-inch piece. Cut pears into wedges. Trim and scrub beet, then cut carrots and celery into 2 to 3-inch pieces. Push pears and ginger through juice extractor. Working in batches, push carrots, celery, beet, and parsley through juice extractor. Stir in lemon juice. Divide between two 8-ounce glasses and serve. ', 'removes toxin', 315);
INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (6, 'Lemon cake ', 'Put oven rack in middle position and preheat oven to 350F. Grease springform pan with some oil, then line bottom with a round of parchment paper. Oil parchment. Finely grate enough lemon zest to measure 1 1/2 teaspoons and whisk together with flour. Halve lemon, then squeeze and reserve 1 1/2 tablespoons fresh lemon juice. Beat together yolks and 1/2 cup sugar in a large bowl with an electric mixer at high speed until thick and pale, about 3 minutes. Reduce speed to medium and add olive oil (3/4 cup) and reserved lemon juice, beating until just combined (mixture may appear separated). Using a wooden spoon, stir in flour mixture (do not beat) until just combined. Beat egg whites (from 4 eggs) with 1/2 teaspoon salt in another large bowl with cleaned beaters at medium-high speed until foamy, then add 1/4 cup sugar a little at a time, beating, and continue to beat until egg whites just hold soft peaks, about 3 minutes. Gently fold one third of whites into yolk mixture to lighten, then fold in remaining whites gently but thoroughly. Transfer batter to springform pan and gently rap against work surface once or twice to release any air bubbles. Sprinkle top evenly with remaining 1 1/2 tablespoons sugar. Bake until puffed and golden and a wooden pick or skewer inserted in center of cake comes out clean, about 45 minutes. Cool cake in pan on a rack 10 minutes, then run a thin knife around edge of pan and remove side of pan. Cool cake to room temperature, about 1 1/4 hours. Remove bottom of pan and peel off parchment, then transfer cake to a serving plate. ', 'rich in vitamin c', 3000);
INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (7, 'Vegan French Toast ', '1. In a bowl, mix together the nondairy milk, flour, sugar, and cinnamon to form a batter. 2. Dip bread in batter and fry in pan with a little oil until golden brown. 3. Serve and enjoy! ', 'high carbs', 685);
INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (8, 'Salmon Fillet with Soy Glaze ', 'Preheat oven to 450F. Line bottom of a broiler pan with foil, then oil rack of pan. Boil soy sauce and maple syrup in a small saucepan over moderate heat until glaze is reduced to 1/3 cup, about 5 minutes. Arrange salmon, skin side down, on rack of broiler pan and pat dry. Reserve 1 1/2 tablespoons glaze in a small bowl for brushing after broiling. Brush salmon generously with some of remaining glaze. Let stand 5 minutes, then brush with more glaze. Roast salmon in middle of oven 10 minutes. Turn on broiler and brush salmon with glaze again, then broil 4 to 5 inches from heat until just cooked through, 3 to 5 minutes. Transfer salmon with 2 wide metal spatulas to a platter, then brush with reserved glaze using a clean brush. ', 'high protein', 900);
INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (9, 'Gingerbread Man ', 'Sift together the Flour, bicarbonate of soda, ginger and cinnamon into a clean bowl. Add the butter, in chunks, to the bowl. Using your fingers crumb the mixture until the butter is fully combined and the mix looks like breadcrumbs. Gently microwave the Golden Syrup to loosen its consistency, once it has cooled slightly, add the add and lightly beat the mixture together. Pour the Syrup & Egg mixture into the flour mix and combine with a plastic spatula. Turn the combined mixture onto a gently floured surface and kneed the dough until soft. Wrap the dough in cling-film and allow to firm-up in the fridge for 15 minutes. Preheat the oven to 180C/350F/Gas 4. Line two baking trays with baking parchment. Remove the dough from the fridge and using a surface dusted with flour, roll the pastry out to 0.5cm/0.25in thick. Using cutter, cut the dough into the desired shape and place on a baking tray leaving space around each one (they expand slightly in the oven). Bake for 12-15 minutes, or until lightly-golden brown. Remove from the oven and leave to cool for 10 minutes, after which they should be thoroughly cooled on a wire rack. ', 'high fiber', 3000);
INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (10, 'Cola Chops ', 'Preheat oven to 350 degrees F (175 degrees C). Place pork chops in a 9x13 inch baking dish. In a small bowl, mix together the cola and ketchup. Pour over chops and sprinkle with brown sugar. Bake uncovered for about 1 hour, or until pork is cooked through and internal temperature has reached 145 degrees F (63 degrees C). ', 'high protein', 1600);
INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (11, 'Egg Salad ', 'Place eggs in a medium saucepan with enough cold water to cover, and bring to a boil. Cover saucepan, remove from heat, and let eggs stand in hot water for 10 to 12 minutes. Remove from hot water, cool, peel, and chop. In a large bowl, mix eggs, mayonnaise, pepper, and paprika. Mash with a potato masher or fork until smooth. Gently stir in the olives. Refrigerate until serving. ', 'high protein', 450);
INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (12, 'Strawberry French Toast ', 'Toast the bread and place in an oven dish. Mix/beat milk, ounce sugar and eggs. Pour mixture over bread and refrigerate overnight for total absorption and to get right moisture. Breakfast morning: Preheat oven to 400 degrees. In a large frying pan, melt butter with another ounce of sugar and cook the soaked slices of bread until golden on each side. Place slices of bread on an oven rack and arrange strawberry slices. Sprinkle with third ounce of sugar and bake for 4 minutes until berries start melting. ', 'high carb', 1470);
INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (13, 'Gnocchi ', 'Lightly beat egg. Bring a large pot of salted water to a boil. Drop in potatoes and cook until tender but still firm, about 15 minutes. Drain, cool slightly, and peel. Season with salt, then mash potatoes with fork, masher, or in ricer. Place in large bowl, and stir in egg and olive oil. Knead in enough flour to make a soft dough.\r On a floured surface, roll dough into a long rope. Cut the rope into 1/2-inch pieces.\r Bring a large pot of lightly salted water to a boil. Drop in gnocchi, and cook until they float to the top, about 3 to 5 minutes. Serve with pasta sauce. ', 'high carb', 1590);
INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (14, 'Brown Rice ', 'Place Rice in a pot and cover with water. Add Salt and oil. Allow rice to come to a rolling boil, turn heat down to low, cover and cook for 35 min. Remove pot from heat allow to sit for 5-10. Fluff with fork. ', 'high fiber content', 920);
INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (15, 'Date Energy Bars ', 'Place 1 cup of each ingredient into blender or food processor. Mix until well blended. Transfer to a sheet of waxed paper; form into a square, folding sides of waxed paper over the top. Cut into 10 bricks. Refrigerate until solid, at least 30 minutes. ', 'high fiber content', 1880);
INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (16, 'Sweet and Spicy Bacon ', 'Preheat oven to 350F. Stir together brown sugar, cayenne, and black pepper in a small bowl.Arrange bacon slices in l layer on a large broiler pan and bake in middle of oven (or upper third of oven if baking with eggs) 20 minutes. Turn slices over and sprinkle evenly with spiced sugar. Continue baking until bacon is crisp and brown, 15 to 20 minutes more, then transfer to paper towels to drain. ', 'contains essential vitamins and minerals', 650);
INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (17, 'Macroni ', 'Preheat oven to 375 degrees F (190 degrees C). Bring a large pot of lightly salted water to a boil. Add pasta and cook for 8 to 10 minutes or until al dente; drain. Grease a 2 quart casserole dish. Place a quarter of the macaroni in the bottom, followed by an even layer of one-quarter of the cheese slices. Dot with butter and season with salt and pepper. Repeat layering three times. Pour evaporated milk evenly over the top of all.Bake, uncovered, for one hour, or until top is golden brown. ', 'high fiber content', 2660);
INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (18, 'Spaghetti Carbonara ', 'Boil a large pot of well salted water, then cook the pasta according to the package directions. For dried spaghetti I usually boil the noodles for 8 minutes rather than the 9 recommended on the package to ensure they are al dente. Combine the Parmesan, egg, olive oil and black pepper in a large bowl and whisk together until the mixture is smooth and there are no clumps of egg whites. Chop the Bacon into batons and add to a pan over medium high heat and fry until cooked through. Drain the pasta (do not rinse), then immediately dump it into the egg mixture. Its important that the pasta be very hot, otherwise the egg mixture will not thicken into a sauce. Add the bacon and toss to coat evenly. Plate your Spaghetti Carbonara and top with a slow cooked egg. ', 'high fiber content', 1530);
INSERT INTO RECIPE (RECIPE_ID, RECIPE_NAME, PREPARATION) VALUES (19, 'Spicy Garlic Brocolli ', 'Cut broccoli into bite sized pieces. Boil in salted water for about 5 to 7 minutes (broccoli should just start to soften). Rinse under COLD water (to stop the cooking). Dry to remove any excess water. In a large skillet, heat the oil until hot. Add the garlic and pepper flakes. Saut\u00e9 for 1 minute. Add the broccoli and some of the broth. Cook for 2 to 4 minutes (depending on the way you like your broccoli, tender or crisp) stirring the entire time. Season lightly with table salt. ', 'high fiber content', 580);

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
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (4,3,1.5,"tbsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (4,6,1.0,"clove");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (4,18,2.5,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (4,19,0.25,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (5,20,1.0,"");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (5,21,2.0,"stalk");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (5,22,0.5,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (5,23,2.0,"tsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (5,24,5.0,"");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (5,25,2.0,"");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (5,26,1.0,"slice");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (6,4,5.0,"");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (6,8,4.0,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (6,27,5.0,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (6,28,1.0,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (6,29,1.0,"");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (7,16,4.0,"slice");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (7,27,3.0,"tbsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (7,28,4.0,"tbsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (7,30,2.0,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (7,31,1.0,"tsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (7,32,1.0,"tbsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (8,33,0.25,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (8,34,0.25,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (8,35,16.0,"oz");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (9,3,125.0,"grm");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (9,4,1.0,"");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (9,6,2.0,"tsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (9,28,350.0,"grm");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (9,31,1.0,"tsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (9,33,4.0,"tbsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (9,36,175.0,"grm");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (9,37,1.0,"tsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (10,36,4.0,"tbsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (10,38,8.0,"fl.oz");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (10,39,1.0,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (10,40,500.0,"grm");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (11,4,4.0,"");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (11,10,0.5,"tsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (11,41,0.25,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (11,42,0.125,"tsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (11,43,15.0,"grm");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (12,3,56.0,"grm");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (12,4,3.0,"");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (12,7,1.0,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (12,12,2.0,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (12,16,4.0,"slice");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (12,27,45.0,"grm");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (13,4,1.0,"");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (13,8,1.0,"tbsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (13,11,1.0,"dash");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (13,28,1.0,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (13,45,6.0,"");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (14,11,1.0,"tsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (14,46,1.0,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (14,47,2.0,"tbsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (14,48,2.0,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (15,49,10.0,"");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (15,50,1.0,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (15,51,1.0,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (16,1,12.0,"strip");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (16,10,0.25,"tsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (16,36,1.5,"tbsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (16,52,0.25,"tsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (17,3,1.0,"tbsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (17,10,1.0,"dash");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (17,11,1.0,"dash");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (17,17,16.0,"oz");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (17,44,1.0,"can");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (17,53,1.0,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (18,1,10.0,"strip");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (18,4,1.0,"");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (18,8,2.0,"tbsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (18,10,1.0,"dash");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (18,54,0.5,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (18,55,6.0,"oz");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (19,6,4.0,"clove");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (19,8,2.0,"tbsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (19,52,1.0,"tsp");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (19,56,0.5,"cup");
INSERT INTO recipeingredient(RECIPE_ID, INGREDIENT_ID, QUANTITY, UNIT_ABBREVIATION) VALUES (19,57,2.0,"lb"}]

INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',1,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',2,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',3,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',4,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',5,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',6,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',7,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',8,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',9,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',10,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',11,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',12,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',13,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',14,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',15,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',16,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',17,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',18,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',19,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',20,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',21,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',22,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',23,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',24,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',25,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',26,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',27,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',28,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',29,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',30,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',31,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',32,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',33,0);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',34,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',35,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',36,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',37,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',38,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',39,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',40,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',41,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',42,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',43,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',44,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',45,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',46,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',47,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',48,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',49,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',50,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',51,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',52,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',53,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',54,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',55,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',56,1);
INSERT INTO AccountIngredient(USERNAME, INGREDIENT_ID, IS_SEARCHABLE) VALUES ('jsmith',57,1);
