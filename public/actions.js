
$(document).ready(function(){
	$("#panel").hide();
	$(".track_name").hide();
	$(".list").mouseover(function(){
			$(this).find('.track_name').fadeIn('medium');
		});

	$(".list").mouseout(function(){
			$(this).find('.track_name').fadeOut('slow');
		});
	$(".list").click(function(){
			feedURL($(this).attr('id'));
			$("#panel").show();
		});
	function feedURL(song)
		{
			$.ajax({
				type: "GET",
				url: "/track",
				data: {track: song},
				success: function(data){
						$("#panel").html(data);
					}
				});
			
		}
});