$(function () {
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
});