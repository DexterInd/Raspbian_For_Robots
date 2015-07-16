(function($){
    $.fn.viewportChecker = function(useroptions){
       
        var options = {
            classToAdd: 'eds-scroll-visible',
            offset: 75,
            callbackFunction: function(elem){}
        };
        $.extend(options, useroptions);

       
        var $elem = this,
            windowHeight = $(window).height();

        this.checkElements = function(){
            
            var scrollElem = ((navigator.userAgent.toLowerCase().indexOf('webkit') != -1) ? 'body' : 'html'),
                viewportTop = $(scrollElem).scrollTop(),
                viewportBottom = (viewportTop + windowHeight);

            $elem.each(function(){
                var $obj = $(this);
                var scroll_offset = $obj.attr('eds_scroll_offset');
                
                if ($obj.hasClass(options.classToAdd)){
                    return;
                }

                var elemTop = '';
                if(scroll_offset != null && scroll_offset != ''){
                	elemTop = Math.round( $obj.offset().top ) + Math.round(Number(scroll_offset) * $obj.height() * 0.01),
                    	elemBottom = elemTop + ($obj.height());
                }else{
                	elemTop = Math.round( $obj.offset().top ) + Math.round(options.offset * $obj.height() * 0.01),
                	elemBottom = elemTop + ($obj.height());
                }

                // Add class if in viewport
                if ((elemTop < viewportBottom) && (elemBottom > viewportTop)){
                    $obj.addClass(options.classToAdd);

                    
                    options.callbackFunction($obj);
                }
            });
        };
        
        $(window).scroll(this.checkElements);
        this.checkElements();

        
        $(window).resize(function(e){
            windowHeight = e.currentTarget.innerHeight;
        });
    };
})(jQuery);
