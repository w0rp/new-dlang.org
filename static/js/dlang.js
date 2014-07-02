// Making the sidebar stay fixed at certain points, etc.
$(function() {
    "use strict";

    var $aside = $(".extra-column > aside");

    if ($aside.find("#twitter").length >= 1) {
        // Don't do any dynamic fixed position stuff when there's the
        // Twitter module in there.
        return;
    }

    $aside.addClass("scrollable");

    var asideStyle = $aside[0].style;
    var asideTopStop = +$aside.data("offset-top");
    var asideBottomStop = +$aside.data("offset-bottom");

    function adjustSidebar() {
        var scrollTop = window.pageYOffset
            || document.documentElement.scrollTop;

        var windowHeight = $(window).height();

        if (scrollTop > asideTopStop) {
            var docHeight = Math.max(
                document.body.scrollHeight,
                document.body.offsetHeight,
                document.documentElement.clientHeight,
                document.documentElement.scrollHeight,
                document.documentElement.offsetHeight
            );

            // Calculate the number of pixels by which the fixed element's
            // height in the window would overrun the stopping point
            // at the bottom.
            var overrun = asideBottomStop -
                (docHeight - (scrollTop + windowHeight));

            asideStyle.position = "fixed";
            asideStyle.top = "0px";

            if (overrun >= 0) {
                // We are running over the bottom, so
                // subtract that difference.
                asideStyle.maxHeight = windowHeight - overrun + "px";
            } else {
                // We are just past the top point,
                // but the bottom of the element isn't at the bottom.
                asideStyle.maxHeight = windowHeight + "px";
            }
        } else {
            asideStyle.position = "relative";
            asideStyle.top = "0px";

            asideStyle.maxHeight =
                windowHeight - (asideTopStop - scrollTop) + "px";
        }
    }

    $(window).scroll(adjustSidebar);
    $(window).resize(adjustSidebar);

    adjustSidebar();
});

$(function() {
    "use strict";

    $("h1[id], h2[id], h3[id], h4[id]").each(function() {
        var $elem = $(this);

        var $tocLink = $('<a class="toc-link">&para;</a>');
        $tocLink.attr("href", "#" + $elem.attr("id"));
        $elem.append($tocLink);
    });
});
