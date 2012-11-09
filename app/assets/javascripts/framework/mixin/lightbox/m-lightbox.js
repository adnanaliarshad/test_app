// Implements the lightbox mixin. It displays centered modal window at the center
// of the screen, with shadowed background.
//
// Usage:
//
// .m-lightbox
//   = link_to("A link which opens the popup", "#", :class => "m-lightbox_link")
//   .m-lightbox_popup
//     Content...
//     = link_to("A link which closes the popup", "#", :class => "m-lightbox_close")
//
// You also can open and close popups programatically, by
//
//   $.m_lightbox_open_popup($('.m-lightbox_popup'));
//
// and
//
//   $.m_lightbox_close_popups();
//
// TODO: Re-enable for IE
(function ($) {

    var classes = {
        self: 'm-lightbox',
        link: 'm-lightbox_link',
        popup: 'm-lightbox_popup',
        close: 'm-lightbox_close',
        shadow: 'm-lightbox_shadow',
        root: 'l-wrapper'
    };


    function center_window(popup) {
        var parent = popup.offsetParent();
        var x_offset = window.pageXOffset || document.documentElement.scrollLeft;
        var y_offset = window.pageYOffset || document.documentElement.scrollTop;
        var window_width = window.innerWidth || document.documentElement.clientWidth;
        var window_height = window.innerHeight || document.documentElement.clientHeight;
        var margin_x = (window_width - 2 * parent.get(0).offsetLeft);
        var margin_y = (window_height - 2 * parent.get(0).offsetTop);
        var left = (margin_x / 2) + x_offset - (popup.width() / 2);
        var top = (margin_y / 2.2) + y_offset - (popup.height() / 2);
        if (top < 0) {
            top = 0;
        }
        popup.css('left', left + 'px');
        popup.css('top', top + 'px');
    }


    function close_popups() {
        $("." + classes.shadow).remove();
        $("." + classes.popup).each(function () {
            $(this).hide();
        });
    }


    function shading_background(popup) {
        var shadow = $("<div  class='" + classes.shadow + "'></div>");
        shadow.css({width: $(document).width() + "px", height: $(document).height() + "px"});
        shadow.click(function () {
            close_popups();
            return false;
        });
        $('.' + classes.root).append(shadow);
        $('.' + classes.root).append(popup);
        popup.show();
        center_window(popup);
        shadow.animate({opacity: 0.9}, 300);
        popup.animate({opacity: 1}, 300);

    }


    function init_close(self, popup) {
        self.find('.' + classes.close).click(function () {
            close_popups();
            return false;
        });
    }


    function open_popup(self) {
        $(function () {
            close_popups();
            var popup = self.data("popup");
            shading_background(popup);
            $('.' + classes.root).append(popup);
            popup.show();
            center_window(popup);
            popup.animate({opacity: 1}, 300);
        });
    }


    function init_open(self) {
        self.find('.' + classes.link).click(function () {
            var popup_name = $(this).attr('class').match(new RegExp(classes.link + "_(\\S+)"))[1];
            var popup = self.find('.' + classes.popup + "_" + popup_name);

            if (popup.size() > 0) {
                self.data("popup",popup);
            } else {
                popup = self.data("popup");
            }

            if (popup.size() > 0) {
                open_popup(self);
                return false;
            }
        });
    }


    $.m_lightbox_close_popups = function () {
        close_popups();
    };


    $.m_lightbox_open_popup = function (popup) {
        var self = popup.closest('.' + classes.self);
        open_popup(self, popup);
    };


    $.fn.m_lightbox = function () {
        return this.each(function () {
          var self = $(this);
          init_open(self);
          init_close(self);
        });
    };

})(jQuery);
