(function ($) {

    var classes = {
        self: 'b-astro-celebrities'
    };

    function fetch_session_data(self) {
        var data = {};
        if($.cookie('iv_id') != null && $.cookie('iv_id') != '')
        {
            data['username'] = $.cookie('iv_id');
            $(".b-users_profile").append("<div id='overlay'><div></div></div>");
            var path = "/create.js";
            if (document.domain == "ivillage.com"){
               path = "/photo-contests/" + window.location.pathname.split('/')[2] + "/create.js"
                if(window.location.href.indexOf("?facebook=true") > -1) {
                    path = path+"?facebook=true"
                }
            }
            self.load(path, data ,function () {
                $("#overlay").remove();
            });
        }
    }

    function init_filters_switch(self) {
        self.find('.' + classes.more + ' a').click(function () {
            self.find('.' + classes.content).fadeOut(function () {
                self.find('.' + classes.filters).fadeIn();
            });
            return false;
        });
        self.find('.' + classes.filters_close).click(function () {
            self.find('.' + classes.filters).fadeOut(function () {
                self.find('.' + classes.content).fadeIn();
            });
            return false;
        });
        self.find('.' + classes.filters + ' li a').click(function () {
            self.find('.' + classes.filters).hide();
            self.find('.' + classes.spinner).fadeIn();
            var filter = $(this).attr('data_filter');
            var data;
            if (filter !== '') {
                var match = filter.match(/(\w+) (\w+)/);
                data = {};
                data[match[1]] = match[2];
                self.data["slide_type"] = match[2];
            }
            $.ajax({
                url: '/home/celebrities',
                data: data,
                dataType: 'json',
                success: function (data) {
                    Astrology.celebrity_data = data;
                    reset_celeb_data_index(self);
                    fetch_slide(self, 0, 'next', true)
                }
            });
            return false;
        });
    }


    $.fn.b_session = function () {
        return this.each(function () {
            var self = $(this);
            $(document).ready(fetch_session_data(self));
        });
    };

})(jQuery);
