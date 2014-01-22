n = Rapns::Apns::Notification.new
n.app = Rapns::Apns::App.find_by_name("ios_app")
n.device_token = "228278ea7c625995ffa10e5296ec86c76f1dd6ddb03a7f42f634837b23b4c4ee"
n.alert = "내용내용"
n.attributes_for_device = {
  "stamp" => {
    "content" => "내용내용222",
    "type" => "Inbox",
    "story_id" => "9707",
    "phone_id" => "469776CF-D562-4CE8-878F-2952A743D31C",
    "story_date" => "2014-01-06",
    "story_time" => "12:58:19",
    "stamp_name" => ""
  }
}
n.attributes_for_device = {
  "reply" => {
    "registration_id" => "regId",
    "type" => "Stamp",
    "story_id" => "9705",
    "stamps" => "1,2,3",
    "comment" => "코멘트"
  }
}
n.save!


aps =     {
        alert = "hi mom!";
        sound = default;
    };
    foo = bar;

    content = "\Uc544\Uc544\Uc5b4";
        "phone_id" = "469776CF-D562-4CE8-878F-2952A743D31C";
        "stamp_name" = "";
        "story_date" = "2014-01-05";
        "story_id" = 9687;
        "story_time" = "12:58:19";