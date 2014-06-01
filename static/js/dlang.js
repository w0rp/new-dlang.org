$(function() {
    "use strict";

    var $aside = $(".extra-column > aside");
    var asideStyle = $aside[0].style;
    var asideTopStop = +$aside.data("offset-top");
    var asideBottomStop = +$aside.data("offset-bottom");

    function adjustSidebar() {
        var scrollTop = window.pageYOffset
            || document.documentElement.scrollTop;

        if (scrollTop > asideTopStop) {
            var docHeight = Math.max(
                document.body.scrollHeight,
                document.body.offsetHeight,
                document.documentElement.clientHeight,
                document.documentElement.scrollHeight,
                document.documentElement.offsetHeight
            );

            var itemHeight = $aside.height();

            if (docHeight - (scrollTop + itemHeight) < asideBottomStop) {
                // The bottom of the element would now be below the bottom
                // stop point, so hold it in place.
                var newTopPos =
                    docHeight
                    - asideBottomStop
                    - asideTopStop
                    - itemHeight;

                asideStyle.position = "relative";
                asideStyle.top = newTopPos + "px";
            } else {
                // We are just past the top point,
                // but the bottom of the element isn't at the bottom.
                asideStyle.position = "fixed";
                asideStyle.top = "0px";
            }
        } else {
            asideStyle.position = "relative";
            asideStyle.top = "0px";
        }
    }

    $(window).scroll(adjustSidebar);
    $(window).resize(adjustSidebar);
});
