/**
*	jQuery.notice_add() and jQuery.notice_remove()
*	These functions create and remove growl-like notices
*
*   Copyright (c) 2009 Tim Benniks
*
*	Permission is hereby granted, free of charge, to any person obtaining a copy
*	of this software and associated documentation files (the "Software"), to deal
*	in the Software without restriction, including without limitation the rights
*	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
*	copies of the Software, and to permit persons to whom the Software is
*	furnished to do so, subject to the following conditions:
*
*	The above copyright notice and this permission notice shall be included in
*	all copies or substantial portions of the Software.
*
*	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
*	THE SOFTWARE.
*
*	@author 	Tim Benniks <tim@timbenniks.com>
* 	@copyright  2009 timbenniks.com
*	@version    $Id: jquery.notice.js 1 2009-01-24 12:24:18Z timbenniks $
*
*       (modified by Anton Astashov)
*
**/

(function ($) {

    var classes = {
        wrap: 'b-notice',
        item: 'b-notice_item',
        notice: 'notice',
        error: 'error',
        item_wrapper: 'b-notice_item_wrapper',
        close: 'b-notice_item_close'
    };


    $.fn.b_notice = function () {
        this.each(function () {
            var self = $(this);
            self.appendTo($('body'));
            var items = self.find('.' + classes.item);
            items.each(function () {
                var item = $(this);
                var close = $('<div class="' + classes.close + '">x</div>');
                item.append(close);
                close.click(function () {
                    $.notice_remove(item);
                });
                if (item.hasClass(classes.notice)) {
                    setTimeout(
                        function () {
                            $.notice_remove(item);
                        }, 5000);
                }
            });
        });
    };

    $.notice_add = function (options) {
        var defaults = {
            inEffect: {opacity: 'show'}, // in effect
            inEffectDuration: 600, // in effect duration in miliseconds
            stayTime: 5000, // time in miliseconds before the item has to disappear
            text: '', // content of the item
            stay: false, // should the notice item stay or not?
            type: 'notice' // could also be error, succes
        };

        // declare varaibles
        var noticeWrapAll, noticeItemOuter, noticeItemInner, noticeItemClose;

        options = $.extend({}, defaults, options);
        noticeWrapAll = (!$('.' + classes.wrap).length) ? $('<div></div>').addClass(classes.wrap).appendTo('body') : $('.' + classes.wrap);
        noticeItemOuter = $('<div></div>').addClass(classes.item_wrapper);

        noticeItemInner = $('<div></div>').hide().addClass(classes.item + ' ' + options.type);
        noticeItemInner.appendTo(noticeWrapAll).html('<p>' + options.text + '</p>');
        noticeItemInner.animate(options.inEffect, options.inEffectDuration).wrap(noticeItemOuter);

        noticeItemClose = $('<div></div>').addClass(classes.close).prependTo(noticeItemInner).html('x');
        noticeItemClose.click(function () {
            $.notice_remove(noticeItemInner);
        });

        // hmmmz, zucht
        if (navigator.userAgent.match(/MSIE 6/i)) {
            noticeWrapAll.css({top: document.documentElement.scrollTop});
        }

        if (!options.stay) {
            setTimeout(
                function () {
                    $.notice_remove(noticeItemInner);
                }, options.stayTime);
        }

        return noticeItemInner;
    };

    $.notice_remove = function (obj) {
        obj.animate({opacity: '0'}, 600, function () {
            obj.parent().animate({height: '0px'}, 300, function () {
                obj.parent().remove();
            });
        });
    };

})(jQuery);
