$( function () {
	$( "a.share" ).button({ icons : { primary : "ui-icon-person" }, text : false })
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

	$( "a.notify" ).button({ icons : { primary : "ui-icon-info" }, text : false })
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
	
	$('a.deletebutton').button({ icons : { primary : "ui-icon-close" }, text : false });
	$('a.setpublicbutton').button({ icons : { primary : "ui-icon-folder-open" }, text : false });
	$('a.setprivatebutton').button({ icons : { primary : "ui-icon-folder-collapsed" }, text : false });
	$('a.editbutton').button({ icons : { primary : "ui-icon-pencil" }, text : false });
	$('a.downloadbutton').button({ icons : { primary : "ui-icon-arrowthickstop-1-s" }, text : false });
	$('a.shared_downloadbutton').button({ icons : { primary : "ui-icon-arrowthickstop-1-s" }, text : true });
	$('a.sharebutton').button({ icons : { primary : "ui-icon-person" }, text : false });
	$('a.notifybutton').button({ icons : { primary : "ui-icon-info" }, text : false })
});
