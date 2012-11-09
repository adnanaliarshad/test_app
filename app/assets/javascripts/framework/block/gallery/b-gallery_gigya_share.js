(function ($) {

    var classes = {
        prev: 'jcarousel-prev',
        next: 'jcarousel-next',
        gallery_share: 'b-gallery_entry_social_share',
        fb_share: 'b-gallery_entry_social_share_fb',
        tw_share: 'b-gallery_entry_social_share_tw',
        pi_share: 'b-gallery_entry_social_share_pi'

    };

    function showShareUI(operationMode, self) {
      var act = new gigya.socialize.UserAction();
      var title = $(self).parent().parent().find('h4').html();
      act.setTitle(title);
      //act.setSubtitle(title);
      act.setDescription("Share a photo of your greatest Halloween costume for the chance to win $2,000!");
      //act.addActionLink("Gigya site", "http://www.gigya.com");
      var img_id = $(self).attr('image_id');
      var link = "http://www.ivillage.com/photo-contests/" + $('#contest_name').text() + "/slides/" + img_id;

      act.setLinkBack(link);
      var img_src = $(self).attr('image')
      var image = {
        type: 'image',
        src: img_src,
        href: link
      }
      act.addMediaItem(image);
      var params =
      {
        userAction: act
        ,operationMode: operationMode
        ,snapToElementID: $(self).attr('id')
        ,enabledProviders: "facebook,twitter,yahoo,linkedin,myspace,messenger"
        ,moreEnabledProviders: "pinterest,gmail,googleplus,googlebookmarks"
        ,context: operationMode
        ,showMoreButton: true
        ,showEmailButton: true

      };
      gigya.socialize.showShareUI(params);
    }

    function init_gigya(self) {
        var interval = setInterval(function() {
            if (typeof gigya !== "undefined") {
                clearInterval(interval);
                init_gigya_share(self);
            }
        }, 1000);
    };

    function init_gigya_share(self) {
        self.find('#' + classes.fb_share).live('click', function() {
          var self = this;
          showShareUI('multiSelect',self);

          if (typeof s_iv !== "undefined" && s_iv !== null) {
            s_iv.linkTrackVars = "products,events,eVar61,event61";
              s_iv.linkTrackEvents = "event61";
              s_iv.eVar61= Votigo.contest_name + "|facebook";
              s_iv.products = ";" + Votigo.contest_name + ":" + $(self).attr('image_name');
              s_iv.tl(self,'o',$(self).attr('image'));
          }
          return false;
        });
        self.find('#' + classes.tw_share).live('click', function() {
          var self = this;
          showShareUI('multiSelect',self);
            if (typeof s_iv !== "undefined" && s_iv !== null) {
          s_iv.linkTrackVars = "products,events,eVar61,event61";
          s_iv.linkTrackEvents = "event61";
          s_iv.eVar61 = Votigo.contest_name + "|twitter";
          s_iv.products = ";" + Votigo.contest_name + ":" + $(self).attr('image_name');
          s_iv.tl(self,'o',$(self).attr('image'));
            }
          return false;
        });
        self.find('#' + classes.pi_share).live('click', function() {
          var self = this;
          showShareUI('multiSelect',self);
            if (typeof s_iv !== "undefined" && s_iv !== null) {
          s_iv.linkTrackVars = "products,events,eVar61,event61";
          s_iv.linkTrackEvents = "event61";
          s_iv.eVar61 = Votigo.contest_name + "|pinterest";
          s_iv.products = ";" + Votigo.contest_name + ":" + $(self).attr('image_name');
          s_iv.tl(self,'o',$(self).attr('image'));
            }
          return false;
        });
    }

    $.fn.b_gallery_gigya_share = function () {
        return this.each(function () {
            var self = $(this);
            init_gigya(self);
        });
    };

})(jQuery);



