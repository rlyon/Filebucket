$( function () {
	$( ".share a" ).button()
	.click( function() {
		var a = this;
		$("#invitation_form").attr("title", "Share '" + $(a).attr("folder_name") + "' with others" );
		$("#ui-dialog-title-invitation_form").text("Share '" + $(a).attr("folder_name") + "' with others");
		$("#invitation_form #email_addresses").val($(a).attr("folder_emails"))
		$("#invitation_form #folder_id").val($(a).attr("folder_id"));

		$( "#invitation_form" ).dialog({
			height: 400,
			width: 515,
			modal: true,
			buttons: {
				"Share": function() {
					var post_url = $("#invitation_form form").attr("action");
					$.post(post_url,$("#invitation_form form").serialize(), null, "script");
					return false;
				},
				"Unshare": function() {
					var post_url = "/folders/unshare"
					$.post(post_url,$("#invitation_form form").serialize(), null, "script");
					return false;
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			},
			close: function() {

			}
		});
		
		return false;
	});

	$( ".notify a" ).button()
	.click( function() {
		var a = this;
		$("#notification_form").attr("title", "Notify users of changes to '" + $(a).attr("folder_name") + "'" );
		$("#ui-dialog-title-notification_form").text("Notify users of changes to '" + $(a).attr("folder_name") + "'");
		$("#notification_form #email_addresses").val($(a).attr("folder_emails"))
		$("#notification_form #folder_id").val($(a).attr("folder_id"));

		$( "#notification_form" ).dialog({
			height: 400,
			width: 515,
			modal: true,
			buttons: {
				"Notify": function() {
					var post_url = $("#notification_form form").attr("action");
					$.post(post_url,$("#notification_form form").serialize(), null, "script");
					return false;
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			},
			close: function() {

			}
		});

		return false;
	});
	
	$( ".newfolder a" ).button()
	$( ".upload a" ).button();

});
