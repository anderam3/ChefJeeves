$(document).ready(function () {
    $('.caloText').hide();
    $(".benefitText").hide();
    $("#healthText span.health").hover(function () {
        $('.benefitText').show();
    }, function () {
        $('.benefitText').hide();
    });
    $("#healthText i.calo").hover(function () {
        $('.caloText').show();
    }, function () {
        $('.caloText').hide();
    });
});
$(function () {
    $("[name$=LoginButton]").addClass("btn btn-info");
    $("[id$=txtAddIngredient]").autocomplete({
        source: function (request, response) {
            $.ajax({
                url: "IngredientInventory.aspx/GetIngredients",
                data: "{ingredient: '" + request.term + "'}",
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    response($.map(data.d, function (item) {
                        return {
                            label: item.split('-')[0],
                            val: item.split('-')[1]
                        }
                    }))
                }
            });
        },
        select: function (e, i) {
            $("[id$=hfIngredientID]").val(i.item.val);
            $("[id$=imgAddIngredient]").attr("src", "../Images/Ingredients/" + i.item.val + ".jpg")
        },
        minLength: 1
    });
    $("[id$=txtAddDietRestriction]").autocomplete({
        source: function (request, response) {
            $.ajax({
                url: "EditDietRestrictions.aspx/GetDietRestrictions",
                data: "{restriction: '" + request.term + "'}",
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    response($.map(data.d, function (item) {
                        return {
                            label: item.split('-')[0],
                            val: item.split('-')[1]
                        }
                    }))
                }
            });
        },
        select: function (e, i) {
            $("[id$=hfDietRestrictionID]").val(i.item.val);
            $("[id$=imgAddDietRestriction]").attr("src", "../Images/DietRestrictions/" + i.item.val + ".jpg")
        },
        minLength: 1
    });
});