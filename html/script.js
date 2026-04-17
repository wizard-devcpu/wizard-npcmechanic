$(function () {
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }

    display(false);

    window.addEventListener('message', function (event) {
        var item = event.data;
        if (item.action === "open") {
            $("#mechanic-cost").text("[" + item.cost + "$]");
            if (item.available) {
                $("#mechanic-status").text("[Mechanics Online]").css("color", "#ff3a3a");
            } else {
                $("#mechanic-status").text("[Available]").css("color", "#3aff3a");
            }
            display(true);
        } else if (item.action === "hide") {
            display(false);
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
            display(false);
        }
    };

    $("#start-btn").click(function () {
        $.post(`https://${GetParentResourceName()}/callMechanic`, JSON.stringify({}));
        display(false);
    });

    $("#reset-btn").click(function () {
        $.post(`https://${GetParentResourceName()}/restartScript`, JSON.stringify({}));
        display(false);
    });
});