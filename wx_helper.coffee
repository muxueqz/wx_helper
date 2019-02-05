# switch_url = (select_id) ->
    # $("#userSelectionBox").on 'change', ->
        # # text = $(this).find('option').eq(@selectedIndex).text()
        # # if text.length > 1
            # # val = $(this).val()
        # console.log('select')
# origOpen = XMLHttpRequest.prototype.open
# XMLHttpRequest.prototype.open = -> 
    # console.log('xml http request')
        # # console.log('request started!');
        # this.addEventListener('load', function() {
            # console.log('request completed!');
            # console.log(this.readyState); //will always be 4 (ajax is completed successfully)
            # console.log(this.responseText); //whatever the response was
        # });
        # # origOpen.apply(this, arguments);
    # # };
# # })();
origOpen = XMLHttpRequest::open
webwxsync_url = 'https://wx.qq.com/cgi-bin/mmwebwx-bin/webwxsync?'
webwxinit_url = 'https://wx.qq.com/cgi-bin/mmwebwx-bin/webwxinit?'
webwxgetcontact_url = 'https://wx.qq.com/cgi-bin/mmwebwx-bin/webwxgetcontact?'

contact_list = {}

XMLHttpRequest::open = ->
    # @addEventListener 'load', ->
    @addEventListener 'readystatechange', ->
        # console.log 'request completed!'
        bind_mention_user()
      # console.log @readyState
      # #will always be 4 (ajax is completed successfully)
      #whatever the response was
        if @responseURL.lastIndexOf(
            webwxgetcontact_url) == 0
            original_response = @responseText
            modified_response = JSON.parse(original_response)
            console.log 'webwxgetcontact_url request'
            for i in modified_response.MemberList
              contact_list[i.UserName] = i.NickName
        else if @responseURL.lastIndexOf(
            webwxinit_url) == 0
            original_response = @responseText
            modified_response = JSON.parse(original_response)
            console.log 'webwxinit_url request'
            console.log modified_response
        else if @responseURL.lastIndexOf(
            webwxsync_url) == 0 and
                @readyState == 4
            # console.log 'webwxsync_url request'
            original_response = @responseText
            modified_response = JSON.parse(original_response)

            # console.log(this.response)

            if modified_response.AddMsgList.length > 0
              for wx_msg in modified_response.AddMsgList
                console.log wx_msg
                console.log contact_list[wx_msg.FromUserName], wx_msg.FromUserName
                if wx_msg.MsgType == 10002
                    # modified_response.AddMsgList[0].MsgType == 10002
                    Object.defineProperty(this, "response", {writable: true})
                    # modified_response.AddMsgList[0].Content = 'test防撤回'
                    wx_msg.Content = 'test防撤回'
                    GM_notification("有人想撤回消息噢")
                    modified_response = JSON.stringify(modified_response)
                    this.response = modified_response
                else if wx_msg.MsgType in [10000, 10001] and
                  (wx_msg.Content.indexOf "发出红包") > -1
                    console.log "据说发出了红包"
                else if wx_msg.MsgType == 10000
                    GM_notification "据说收到红包"
                # console.log(@)
                # console.log(this.response)
                # console.log "modified_response"
                # console.log(modified_response)
                # console.log @responseText
    origOpen.apply this, arguments

get_users = (source_text) ->
    select = document.getElementById("userSelectionBox")
    # select.onchange = ->
    # select.onselect = ->
    # select = document.getElementById("group_users")
    # select.oninput = ->
    # select.onblur = ->
        # text = $(this).find('option').eq(@selectedIndex).text()
    select.onclick = ->
        text = select.value
        if text.length > 1
            # val = $(this).val()
            val = text
            console.log(val)
            # select.innerHTML = val
            # select = document.getElementById("userSelectionBox")
            # select.remove()
            # new_msg =  source_text + val
            # console.log('new_msg:' + new_msg)
            # send_msg.editAreaCtn = new_msg
            # editarea.innerHTML = new_msg
            # editarea.focus()
            # while select != null
                # select.remove()
                # console.log('remove')
                # select = document.getElementById("group_users")
                # select.remove()

# click_user = () ->
click_user = ->
    console.log('click')

close_userselect = ->
    $('#userSelectionBox').css('display', 'none')

console.log('console log')
GM_notification("wx_helper enable")
GM_addStyle('.main_inner{max-width:70%}')
GM_addStyle('.main{height:88%; padding-top:50px}')
GM_addStyle('.bubble{font-size:16px}')
GM_addStyle('.chat .box_ft .content .flex{font-size:16px}')
# GM_addStyle('.box_hd .title{font-size:18px}')
send_msg = angular.element(document.querySelector(".btn.btn_send")).scope()

editarea = document.getElementById("editArea")
# editarea.oninput = ->
# html = """
# <datalist id="userSelectionBox"
# ">
# </datalist>
# """
html = """
<ul class="dropdown_menu" id="userSelectionBox" style="
    position: absolute;
    display: none;
    width: auto;
    left: 0;
    right: auto;
    top: 50%;
    max-height: 25%;
    /* z-index: 900; */
    right: auto;
    float: left;
    min-height: auto;
    min-width: auto;
    background: transparent;
">
</ul>
"""
# $("body").append(html)
$("#chatArea").append(html)
# $("#userSelectionBox").on 'click', ->
# $("#userSelectionBox").on 'click', text ->
document.getElementById('userSelectionBox').onclick = (a) ->
    # text = $(this)
    text = a.target.name
    console.log(text)
    click_user()

get_input_user = ->
    source_text = editarea.innerHTML
    input = editarea.innerHTML.replace('<br>',
        '').replace('</br>',
        '').split(' ')[-1..][0]
    # console.log ('input:' + input)
    if '@' == input[0] and input.length > 1
        console.log ('@input:' + input)
    # console.log('get input user:' + editarea.textContent)
        html = """
        <select id="userSelectionBox">
            <option value='#{item}'>#{item}</option>
        </select>
        """
        # html = """
        # <datalist id="userSelectionBox" style="
        # display: block;
        # background: #f9f9f9;
        # ">
        # html = """
        # <input list="userSelectionBox" name="userSelectionBox" id="group_users" type="text"  multiple='multiple'>
        # """
        newMessage = html
        # editarea.innerHTML = editarea.innerHTML + newMessage

        scope = angular.element('#chatArea').scope()
        # scope.currentContact.MemberList
        # member_list = scope.currentContact.MemberList.map(m => {console.log(m.NickName)})
        member_list = []
        # member_list = member_list.map(member) -> member.NickName
        # member_list = (member.NickName for member in member_list)

        # fix '@'
        input_user = input[1..-2]
        input_user_lower = input[1..-2].toLowerCase()
        $('#userSelectionBox').empty()
        for member in scope.currentContact.MemberList
            item = member.NickName
            # console.log(item, input_user)
            if item.toLowerCase().lastIndexOf(
                input_user_lower) != -1 and input_user_lower.length > 0
            # if true
                # item = "<option value='#{item}'>#{item}</option>"
                html_item = """
                    <li>
                        <a href="javascript:;" title="#{item}" name="#{item}">
                            #{item} </a>
                    </li>
    """
                # html_item = """
                    # <li>
                        # <a onclick="click_user();" title="#{item}">
                            # #{item} </a>
                    # </li>
    # """
                $('#userSelectionBox').append(html_item)
                console.log(html_item)
                member_list.push item
        console.log(member_list)
        # editarea.innerHTML = ''
        # editarea.scope().insertToEditArea(newMessage)
        # new_html =  editarea.textContent + newMessage
        # console.log(new_html)
        #
        # setTimeout(get_users, 1000)
        clean_index = input.lastIndexOf(input_user) - (2 + input_user.length + 1)
        console.log 'clean_index:' + clean_index
        console.log 'input_user:' + input_user

        console.log('source:' + source_text[..clean_index])
        # get_users(source_text[..clean_index])
        console.log('member_list length:' + member_list.length)
        if member_list.length > 0
            # editarea.focus()
            new_msg = source_text[..clean_index] + member_list.pop() + ' '
            editarea_ng = angular.element('#editArea')

            # editarea_ng = $('#editArea')

            editarea_ng.focus()
            editarea_ng.html('')
            editarea_scope = editarea_ng.scope()
            editarea_scope.insertToEditArea(new_msg)
            console.log('new_msg:' + new_msg)
            # $('#userSelectionBox').css('display', 'flex')
            $('#userSelectionBox').css('display', 'block')
            setTimeout(close_userselect, 3000)

# editarea.onkeyup = (key) ->
# editarea.oninput = ->
 # editarea.onblur = ->
    # console.log(editarea.textContent)
editarea.onkeypress = (key) ->
    console.log('keypress:' + key.key)
    if key.key == '@'
        setTimeout(get_input_user, 10)
        # get_input_user()
    # if key.key == '@'
    # if key.key == '@'
    # setTimeout(get_input_user(), 100000)
    #
bind_mention_user = ->
    # console.log('rebind editarea')
    editarea = document.getElementById("editArea")
    editarea.onkeypress = (key) ->
        console.log('keypress:' + key.key)
        if key.key == '@'
            setTimeout(get_input_user, 10)

do poll = ->
    bind_mention_user()
    setTimeout poll, 1000
