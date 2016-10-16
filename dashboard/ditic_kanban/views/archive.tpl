<style>
    body {
        background-color:#eeeeee;
        font-family: "Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;
        color:#555;
    }

    #ticketName{
      font-weight: bold;
      color: #dd890b;
    }

    #header{
        /*Altera o tamanho da barra na janela*/
        margin-top: -10px;
        /*-----------------*/
        width:100%;
        height: 50px;
        background-color: #3c3c3c;
        box-shadow: 0px 3px 1px #b6b6b6;
        padding: 0px 0px 10px 0px;
    }

    table#t03 { 
        background-color: #FFFFFF;
        box-shadow: 2px 2px 1px #b6b6b6;
    }

    #title{
        font-size:large;
        color: #dd890b; 
        font-weight: bold;
        margin-top: -70px;
        /*Altera a posição do titulo na janela*/
        margin-left: 20px;
    }

    #imgSrc{
        width: 63px;
        height: 16px;
    }

</style>

    <script type="text/javascript">
        // Popup window code
        function modifyTicketPopup(url) {
            popupWindow = window.open(
            url,'popUpWindow','height=800,width=400,left=10,top=10,resizable=no,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no,status=no')
        }
    </script>


<body>
    % include('summary')
    % max_len = 30
    <br>
    <br>
    
    <p>
        <strong>My Archived tickets:</strong>
    </p>
    <table border="1" id="t03" align="center" width="50%">
        % if 'resolved' in tickets2['tickets']:
            % for priority in sorted(tickets2['tickets']['resolved'], reverse=True):
            %   priority = str(priority)
            <tr>
                <td valign="top">
                    <strong>{{priority}}</strong>
                </td>
                <td valign="top">
                    <table border="0">
                    %for x in range(len(tickets2['tickets']['resolved'][priority])):
                        %   ticket =  tickets2['tickets']['resolved'][priority][x]
                        <tr>
                            % if ticket['status'] == 'resolved':
                                <td>
                                    &nbsp;&nbsp;
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
                                </td>
                                <td>
                                    &nbsp;&nbsp;
                                    %  if ticket['cf.{ditic - archived}'] == 'yes':
                                    <a href="/ticket/{{ticket['id']}}/action/unarchive?o={{username_id}}&email={{email}}">
                                    <img id="imgSrc" src="http://localhost:8080/static/Images/Unarchive.png" alt="(Unarchive)" /></a>
                                    %  end
                                </td>
                            % end
                        </tr>
                    % end
                    </table>
                </td>
            </tr>
            % end
        % else:
            <tr>
            <td>
                
            </td>
            </tr>
        % end
    </table>
</body>