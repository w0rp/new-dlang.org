$(function() {
    "use strict";

    var $aside = $(".extra-column > aside");
    var asideStyle = $aside[0].style;
    var asideTopStop = +$aside.data("offset-top");
    var asideBottomStop = +$aside.data("offset-bottom");

    if ($aside.find("#twitter").length === 0) {
        // Hack to only enable scrolling when the aside isn't holding
        // the Twitter module.
        $aside.addClass("scrollable");
    }

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
