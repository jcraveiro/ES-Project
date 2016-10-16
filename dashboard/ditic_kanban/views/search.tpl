<style type="text/css">
    #imgSrc{
        width: 63px;
        height: 16px;
    }

    #imgSrc2{
        width: 20px;
        height: 16px;
    }

    #ticketName{
      font-weight: bold;
      color: #dd890b;
    }

    #ticketName2{
      font-weight: bold;
      color: #ff0000;
    }

    table#t1 { 
        background-color: #FFFFFF;
        box-shadow: 2px 2px 1px #b6b6b6;
        margin-left:auto; 
        margin-right:auto;
    }


</style>

% include('summary')
% max_len = 80


% email2 = get('username')

<p>
    <strong>Searching for (last 90 days): </strong><i>{{email}}</i><br>
    <strong># Tickets:</strong> <i>{{len(tickets2['tickets'])}}</i>
</p>

% action_result = get('action_result', '')
% if action_result:
<p>
    <strong>Action:</strong> <i>{{action_result}}</i>
</p>
% end

    <script type="text/javascript">
        // Popup window code
        function modifyTicketPopup(url) {
            popupWindow = window.open(
            url,'popUpWindow','height=800,width=400,left=10,top=10,resizable=no,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no,status=no')
        }
    </script>

    <script type="text/javascript">
        // Popup window code
        function newPopup(url) {
            popupWindow = window.open(
            url,'popUpWindow','height=400,width=600,left=10,top=10,resizable=no,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no,status=no')
        }
    </script>

<table id="t1" border="1" width="60%">
    % ticketLst = tickets2['tickets']
    % for ticket in ticketLst:
        <tr>
            <td valign="top">
                {{ticket['priority']}}
                &nbsp;&nbsp;
                % if ticket['cf.{ditic - urgent}'] == 'yes':
                <a id="ticketName2" title="#{{ticket['id']}}

    Owner: {{ticket['owner']}}
    Status: {{ticket['status']}}
    TimeWorked: {{ticket['timeworked']}}
    Created: {{ticket['created']}}<br>
    Last Update: {{ticket['lastupdated']}}

    Requestor: {{ticket['requestors']}}
    Subject: {{ticket['subject']}}" href="JavaScript:modifyTicketPopup('/ticketDetails/{{ticket['id']}}');">
                    {{ticket['id']}}
                    % subject = ticket['subject']
                    % if len(ticket['subject']) > max_len:
                    %   subject = ticket['subject'][:max_len]+'...'
                    % end
                    {{subject}}
                </a>
                % else:
                <a id="ticketName" title="#{{ticket['id']}}

    Owner: {{ticket['owner']}}
    Status: {{ticket['status']}}
    TimeWorked: {{ticket['timeworked']}}
    Created: {{ticket['created']}}<br>
    Last Update: {{ticket['lastupdated']}}

    Requestor: {{ticket['requestors']}}
    Subject: {{ticket['subject']}}" href="JavaScript:modifyTicketPopup('/ticketDetails/{{ticket['id']}}');">
                    {{ticket['id']}}
                    % subject = ticket['subject']
                    % if len(ticket['subject']) > max_len:
                    %   subject = ticket['subject'][:max_len]+'...'
                    % end
                    {{subject}}
                </a>
                % end
                <br>
                % if ticket['kanban_actions']['back']:
                <a href="/ticket/{{ticket['id']}}/action/back?o={{username_id}}&email={{email2}}"><img id="imgSrc" src="http://localhost:8080/static/Images/Back.png" alt="(Back)"/></a>
                % end
                % if ticket['kanban_actions']['interrupted']:
                <a href="/ticket/{{ticket['id']}}/action/interrupted?o={{username_id}}&email={{email2}}"><img id="imgSrc" src="http://localhost:8080/static/Images/Interrupt.png" alt="(Interrupt)" /></a>
                % end
                % if ticket['kanban_actions']['increase_priority']:
                <a href="/ticket/{{ticket['id']}}/action/increase_priority?o={{username_id}}&email={{email2}}"><img id="imgSrc2" src="http://localhost:8080/static/Images/PriUp.png" alt="^" /></a>
                % end
                % if ticket['kanban_actions']['decrease_priority']:
                <a href="/ticket/{{ticket['id']}}/action/decrease_priority?o={{username_id}}&email={{email2}}"><img id="imgSrc2" src="http://localhost:8080/static/Images/PriDown.png" alt="v" /></a>
                % end
                % if ticket['kanban_actions']['stalled']:
                <a href="/ticket/{{ticket['id']}}/action/stalled?o={{username_id}}&email={{email2}}"><img id="imgSrc" src="http://localhost:8080/static/Images/Stall.png" alt="(Stall)" /></a>
                % end
                % if ticket['kanban_actions']['forward'] and ticket['status'] != 'open':
                <a href="/ticket/{{ticket['id']}}/action/forward?o={{username_id}}&email={{email2}}"><img id="imgSrc" src="http://localhost:8080/static/Images/Forward.png" alt="(Forward)" /></a>
                % end
                 % if ticket['kanban_actions']['forward'] and ticket['status'] == 'open':
                <a href="JavaScript:newPopup('/addComment/{{ticket['id']}}');"><img id="imgSrc" src="http://localhost:8080/static/Images/Forward.png" alt="(Forward)" /></a>
                % end
                % if ticket['status'] == 'new':
                <a href="/ticket/{{ticket['id']}}/action/take?o={{username_id}}&email={{email2}}">
                <img id="imgSrc" src="http://localhost:8080/static/Images/Take.png" alt="(Take)" /></a>
                %   if ticket['cf.{ditic - urgent}'] == 'yes':
                    <a href="/ticket/{{ticket['id']}}/action/unset_urgent?o={{username_id}}&email={{email2}}" title="Make ticket not urgent">
                    <img id="imgSrc" src="http://localhost:8080/static/Images/NotUrgent.png" alt="(Not Urg.)" /></a>
                %   else:
                    <a href="/ticket/{{ticket['id']}}/action/set_urgent?o={{username_id}}&email={{email2}}" title="Make ticket URGENT">
                    <img id="imgSrc" src="http://localhost:8080/static/Images/Urgent.png" alt="(Urg.)" /></a>
                %   end
                % end
            </td>
        </tr>
    % end
</table>

<p>
    Time to execute: {{time_spent}}
</p>
