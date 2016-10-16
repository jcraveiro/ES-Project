
<style>

    #ticketName{
      font-weight: bold;
      color: #dd890b;
    }

    #ticketName2{
      font-weight: bold;
      color: #ff0000;
    }


    body {
        background-color: #eeeeee;
        width: 100%;
    }

    table#t03 { 
        background-color: #FFFFFF;
        margin-right: 10px;
        margin-left: 10px;
        box-shadow: 2px 2px 1px #b6b6b6;
    }

    table#t02 { 
        background-color: #FFFFFF;
    }

    #imgSrc{
        width: 63px;
        height: 16px;
    }

    #imgSrc2{
        width: 20px;
        height: 16px;
    }

</style>

<body>


    % include('summary')
    % max_len = 30

    <p>
    <script type="text/javascript">
		// Popup window code
		function newPopup(url) {
			popupWindow = window.open(
			url,'popUpWindow','height=400,width=600,left=10,top=10,resizable=no,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no,status=no')
		}
	</script>

	<script type="text/javascript">
		// Popup window code
		function modifyTicketPopup(url) {
			popupWindow = window.open(
			url,'popUpWindow','height=800,width=400,left=10,top=10,resizable=no,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no,status=no')
		}
	</script>

     
    </p>

    % action_result = get('action_result', '')
    % if action_result:
    <p>
        <strong>Action:</strong> <i>{{action_result}}</i>
    </p>
    % end

    <table align="center" id="t03" border="1" width="98%">
        <tr>
            <td  align="center">
                <strong>INBOX</strong>
            </td>
            <td align="center">
                <strong>IN</strong><br>
                % status = 'new'
                % if status in number_tickets_per_status:
                    <strong>{{number_tickets_per_status[status]}}</strong>
                % end
                % if status in email_limit:
                    (max: {{email_limit[status]}})
                % end
            </td>
            <td align="center">
                <strong>ACTIVE</strong><br>
                % status = 'open'
                % if status in number_tickets_per_status:
                    <strong>{{number_tickets_per_status[status]}}</strong>
                % end
                % if status in email_limit:
                    (max: {{email_limit[status]}})
                % end
            </td>
            <td align="center"><strong>RESOLVED</strong><br>
            <td align="center"><strong>STALLED</strong></td>
            </td>
        </tr>
        <tr>
            <td height="100%">
                <table id="t02" height="100%" width="100%" border="1" rules="all" frame="void">
                    % for priority in sorted(tickets2['tickets'], reverse=True):
                    %   priority = str(priority)
                    <tr align="right">
                        <td align="center" valign="center">
                            <strong>{{priority}}</strong>
                        </td>
                        <td valign="top">
                            <table width="100%">
                            %for x in range(len(tickets2['tickets'][priority])):
                            %   ticket =  tickets2['tickets'][priority][x]
                                <tr>
                                    <td align="center" rowspan="2">
                                        % if ticket['cf.{ditic - urgent}'] == 'yes' and ticket['status'] != 'resolved':
                                        <audio autoplay loop>
                                            <source src="http://localhost:8080/static/alert1.mp3" type="audio/mpeg">
                                        </audio>
                                        % end
                                        % if ticket['cf.{ditic - urgent}'] == 'yes':
                                        <audio autoplay loop>
                                            <source src="http://localhost:8080/static/alert1.mp3" type="audio/mpeg">
                                        </audio>
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
                                    </td>
                                    <tr>
                                        <td align="right">
                                            &nbsp;
                                            % if ticket['kanban_actions']['increase_priority']:
                                            <a href="/ticket/{{ticket['id']}}/action/increase_priority?o={{username_id}}&email={{email}}">
                                                <img id="imgSrc2" src="http://localhost:8080/static/Images/PriUp.png" alt="^" />
                                            </a>
                                            % end
                                            <a href="/ticket/{{ticket['id']}}/action/take?o={{username_id}}&email={{email}}">
                                            <img id="imgSrc" src="http://localhost:8080/static/Images/Take.png" alt="(Take)" /></a>
                                            
                                            <br>

                                            % if ticket['kanban_actions']['decrease_priority']:
                                            <a href="/ticket/{{ticket['id']}}/action/decrease_priority?o={{username_id}}&email={{email}}">
                                            <img id="imgSrc2" src="http://localhost:8080/static/Images/PriDown.png" alt="v" /></a>
                                            % end
                                            %   if ticket['cf.{ditic - urgent}'] == 'yes':
                                            <a href="/ticket/{{ticket['id']}}/action/unset_urgent?o={{username_id}}&email={{email}}" title="Make ticket not urgent">
                                            <img id="imgSrc" src="http://localhost:8080/static/Images/NotUrgent.png" alt="(Not Urg.)" /></a>
                                            %   else:
                                            <a href="/ticket/{{ticket['id']}}/action/set_urgent?o={{username_id}}&email={{email}}" title="Make ticket URGENT">
                                            <img id="imgSrc" src="http://localhost:8080/static/Images/Urgent.png" alt="(Urg.)" /></a>
                                            %   end
                                            
                                        </td>
                                    </tr>
                                </tr>
                            % end
                            </table>
                        </td>
                    </tr>
                    % end

                </table>
        </td>
            % for status in ['new', 'open', 'resolved', 'stalled']:
            %   if status not in tickets.keys():
            <td>
            </td>
            %
            %       continue
            %   end
            <td valign="top">
            %   for priority in sorted(tickets[status], reverse=True):
                % for ticket in tickets[status][priority]:
                &nbsp;&nbsp;
                % if ticket['cf.{ditic - archived}'] == '':
                    {{ticket['priority']}}
                    % if ticket['cf.{ditic - urgent}'] == 'yes' and ticket['status'] != 'resolved':
                    <audio autoplay loop>
                        <source src="http://localhost:8080/static/alert1.mp3" type="audio/mpeg">
                    </audio>
                    % end
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
                    % if ticket['kanban_actions']['back'] and ticket['owner'] == username:
                    <a href="/ticket/{{ticket['id']}}/action/back?o={{username_id}}&email={{email}}"><img id="imgSrc" src="http://localhost:8080/static/Images/Back.png" alt="(Back)"/></a>
                    % end
                    % if ticket['kanban_actions']['interrupted'] and ticket['owner'] == username:
                    <a href="/ticket/{{ticket['id']}}/action/interrupted?o={{username_id}}&email={{email}}"><img id="imgSrc" src="http://localhost:8080/static/Images/Interrupt.png" alt="(Interrupt)" /></a>
                    % end
                    % if ticket['kanban_actions']['increase_priority'] and ticket['owner'] == username:
                    <a href="/ticket/{{ticket['id']}}/action/increase_priority?o={{username_id}}&email={{email}}"><img id="imgSrc2" src="http://localhost:8080/static/Images/PriUp.png" alt="^" /></a>
                    % end
                    % if ticket['kanban_actions']['decrease_priority'] and ticket['owner'] == username:
                    <a href="/ticket/{{ticket['id']}}/action/decrease_priority?o={{username_id}}&email={{email}}"><img id="imgSrc2" src="http://localhost:8080/static/Images/PriDown.png" alt="v" /></a>
                    % end
                    % if ticket['kanban_actions']['stalled'] and ticket['owner'] == username:
                    <a href="/ticket/{{ticket['id']}}/action/stalled?o={{username_id}}&email={{email}}"><img id="imgSrc" src="http://localhost:8080/static/Images/Stall.png" alt="(Stall)" /></a>
                    % end
                    % if ticket['kanban_actions']['forward'] and ticket['status'] != 'open' and ticket['owner'] == username:
                    <a href="/ticket/{{ticket['id']}}/action/forward?o={{username_id}}&email={{email}}"><img id="imgSrc" src="http://localhost:8080/static/Images/Forward.png" alt="(Forward)" /></a>
                    % end
                    % if ticket['kanban_actions']['forward'] and ticket['status'] == 'open' and ticket['owner'] == username:
                    <a href="JavaScript:newPopup('/addComment/{{ticket['id']}}');"><img id="imgSrc" src="http://localhost:8080/static/Images/Forward.png" alt="(Forward)" /></a>
                    % end
                    % if ticket['status'] == 'resolved' and ticket['owner'] == username:
                    <a href="/ticket/{{ticket['id']}}/action/archive?o={{username_id}}&email={{email}}"><img id="imgSrc" src="http://localhost:8080/static/Images/Archive.png" alt="(Archive)" /></a>
                    % end
                    <br>
                %end
            % end
        %   end
            </td>
            % end
        </tr>
    </table>

    <br>
    <br>


    <p>
        Time to execute: {{time_spent}}
    </p>
</body>