jQuery(document).ready( function($) {	
	$('.love-it').live('click', function() {
		var $this = $(this);	
		var post_id = $this.data('post-id');
		var user_id = $this.data('user-id');
		var data = {
			action: 'love_it',
			item_id: post_id,
			user_id: user_id,
			love_it_nonce: love_it_vars.nonce
		};
		
		// don't allow the user to love the item more than once
		if($this.hasClass('loved')) {
			alert(love_it_vars.already_loved_message);
			return false;
		}	
		if(love_it_vars.logged_in == 'false' && $.cookie('loved-' + post_id)) {
			alert(love_it_vars.already_loved_message);
			return false;
		}
		
		$.post(love_it_vars.ajaxurl, data, function(response) {
			if(response == 'loved') {
				$this.addClass('loved');
				var count_wrap = $this.next();
				var count = count_wrap.text();
				count_wrap.text(parseInt(count) + 1);
				if(love_it_vars.logged_in == 'false') {
					$.cookie('loved-' + post_id, 'yes', { expires: 1 });
				}
			} else {
				alert(love_it_vars.error_message);
			}
		});
		return false;
	});	
});