
<style>

    body {
        background-color: #F0FFFF;
    }

    #ticketName{
      font-weight: bold;
      color: #dd890b;
    }

    #ticketName2{
      font-weight: bold;
      color: #ff0000;
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

% include('summary')
% max_len = 80
<body>

    <p>
        <strong>{{email.upper()}}</strong><br>
        <strong># Tickets:</strong> <i>{{number_tickets_per_status[email]}}</i>
    </p>

    % action_result = get('action_result', '')
    % if action_result:
    <p>
        <strong>Action:</strong> <i>{{action_result}}</i>
    </p>
    % end
    <table id="t02" align="center" border="1" rules="all">
        % for priority in sorted(tickets, reverse=True):
        <tr align="right">
            <td align="center" valign="center">
                <strong>{{priority}}</strong>
            </td>
            <td valign="top">
                <table width="100%">
                %for ticket in sorted(tickets[priority], reverse=True):
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


    <p>
        Time to execute: {{time_spent}}
    </p>
</body>

</script>