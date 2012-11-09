(function ($) {

    var classes = {
        login: 'login_btn',
        login_div: 'login_div',
        login_form: 'b-session_new_form',
        error: 'b-session_new_error'
    };

    function validate_and_submit(self) {
        var form = self.find('.' + classes.login_form + ' form');
        $('.' + classes.login_form).find('.' + classes.error).hide();
        form.submit(function () {
            var is_valid = $.m_validations_validate_all(form);
            if (is_valid) {
                var data;
                data = {};
                data['email'] = $('.' + classes.login_form).find('#user_email').val();
                data['password'] = $('.' + classes.login_form).find('#user_password').val();
                $.ajax({
                    url: '/user/login.js',
                    data: data,
                    dataType: 'json',
                    success: function (data) {
                        console.log(data);
                        window.location.href = data;
                    },
                    error: function (data) {
                        $('.' + classes.login_form).find('.' + classes.error).show();
                        console.log(data);
                    }
                });
                return false;
            } else {
                return false;
            }
        });
    }

    function fetch_login_form(self) {
        self.load("http://www.ivillage.com/ajax/sso-html/login?flow_type=login&vertical=8&_=1339655684713 #login_div",function () {
            //$("#overlay").remove();
        });
    }

    $.fn.b_session_new = function () {
        return this.each(function () {
            var self = $(this);
//            self.find('.' + classes.login).click(function () {
//                fetch_login_form(self);
//                return false;
//            });
            validate_and_submit(self);
        });
    };

})(jQuery);
