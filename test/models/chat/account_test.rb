require 'test_helper'

module Chat
  class AccountTest < ActiveSupport::TestCase

    setup do
      @create_response_body1 = {
        "code": 200,
        "info":{
          "token": "2cf67fc03a9437011e58707b3d556a72",
          "accid": "a37ca1b885bae8d732f88a2ae35218c4",
          "name": ""
        }
      }.to_json

      @create_response_body2 = {
        "code"=>200,
        "uinfos"=>[
          {
            "accid"=>"a37ca1b885bae8d732f88a2ae35218c4",
            "name"=>"teacher_3",
            "gender"=>0
          }
        ]
      }.to_json

    end

    test "set chat account" do
      student = Student.find(users(:student_one_with_course).id)
      account = chat_accounts(:student_chat_account)

      response = Typhoeus::Response.new(code: 200, body: @create_response_body1)
      Typhoeus.stub('https://api.netease.im/nimserver/user/create.action').and_return(response)

      account.set_chat_account

      assert_equal("2cf67fc03a9437011e58707b3d556a72", account.token, '云信用户token不正确')
      assert_equal("a37ca1b885bae8d732f88a2ae35218c4", account.accid, '云信用户accid不正确')
      assert_equal("", account.name, '云信用户name不正确')
    end


    test "update uinfo" do
      teacher = Teacher.find(users(:teacher3).id)
      account = chat_accounts(:chat_account)

      response = Typhoeus::Response.new(code: 200, body: @create_response_body1)
      Typhoeus.stub('https://api.netease.im/nimserver/user/updateUinfo.action').and_return(response)

      account.update_uinfo

      response = Typhoeus::Response.new(code: 200, body: @create_response_body2)
      Typhoeus.stub('https://api.netease.im/nimserver/user/getUinfos.action').and_return(response)

      res = account.get_uinfo

      account.update_columns(accid: res[:accid], name: res[:name])

      assert_equal("a37ca1b885bae8d732f88a2ae35218c4", account.accid, '云信用户accid不正确')
      assert_equal(teacher.nick_name, account.name, '云信用户name不正确')
    end

  end
end
