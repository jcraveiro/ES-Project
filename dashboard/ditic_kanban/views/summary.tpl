<!DOCTYPE html>
<html lang="en">
<head>
    <title>RT DASHBOARD</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>

</head>


<style>

    #text{
        color: #dd890b;
    }

    #header1{
      text-align: center;
      font-weight: bold;
    }

    #header2{
      text-align: center;
      font-weight: bold;
      color: #dd890b;
    }

    table#t02 { 
        background-color: #FFFFFF;
        box-shadow: 2px 2px 1px #b6b6b6;
    }

    body {
        background-color: #eeeeee;
        min-width: 800px;
    }

    table#t01 tr:nth-child(odd) td{
    }
    table#t01 tr:nth-child(even) td{
        background-color:   #e6e6e6;
    }

    .navbar{
        background-color: #3c3c3c;
        box-shadow: 0px 3px 1px #b6b6b6;
        border: none;
        border-radius: 0px;
    }


    #submenu{
        background-color: #4d4d4d;
        color: #dd890b;
        font-weight: bold;
    }

    #submenu2{
        background-color: #3c3c3c;
        color: #dd890b;
    }


</style>

    <script type="text/javascript">
        // Popup window code
        function newPopup2(url) {
            popupWindow = window.open(
            url,'popUpWindow','height=600,width=800,left=10,top=10,resizable=no,scrollbars=,toolbar=no,menubar=no,location=no,directories=no,status=no')
        }
    </script>

<nav class="navbar navbar-default">
  <div class="container-fluid">
    <div class="navbar-header">
      <a id="text" class="navbar-brand">RT Dashboard</a>
    </div>
    <div>
      <ul class="nav navbar-nav">
        <li id="submenu"><a id="submenu" href="/?o={{get('username_id', '')}}">Home</a></li>
      </ul>
    </div>
    <div>
      <ul style="padding-left: 5px;" class="nav navbar-nav">
         
        <li id="submenu"><a id="submenu"href="JavaScript:newPopup2('/createTicket.html')">Create Ticket</a></li>
      </ul>
    </div>
    <div>
      <ul style="padding-left: 5px;" class="nav navbar-nav">
         
        <li id="submenu"><a id="submenu"href="/archives.html/?o={{get('username_id', '')}}">Ticket Archives</a></li>
      </ul>
    </div>
    <div>
        <ul style="padding-left: 5px;" class="nav navbar-nav">
            <li id="submenu"><a id="submenu"href="JavaScript:newPopup2('http://localhost/rt/')">Configuration</a></li>
        </ul>
    </div>
    <div>
        <ul style="padding-left: 5px; padding-top:10px; position: absolute; right: 5px;" class="nav navbar-nav">
            <li align="right">
                <form action="/search?o={{get('username_id', '')}}" method="post">
                    <table>
                        <tr id="submenu2">
                            <input border="0" value="Search..." onClick="value=''"name="search" type="search">
                        </tr>
                    </table>
                </form>
            </li>
        </ul>
    </div>
    <div>
        <ul style="padding-left: 5px;" class="nav navbar-nav">
            <li id="submenu"><a id="submenu"href="/logoutRest">Log Out</a></li>
        </ul>
    </div>
  </div>
</nav>

<body>
    % rebase('skin')

    <p>
        % username = get('username', '')
        % if username:
        <strong>Authenticated as: {{username}}</strong>
        % end
    </p>
    

    <table id="t02" align="center" width="35%" border="1">
        <tr>
            <td id="header1" align="center">INBOX</td>
            <td id="header1" align="center">DITIC Kanban Board</td>
        </tr>
        <tr>
            % # DIR-INBOX
            % sum = 0
            % # we need this code because DIR can have tickets all along several status
            % for status in summary['inbox']:
            %   sum += summary['inbox'][status]
            % end
            <td align="center" valign="top">
                % urgent = get('urgent', '')
                % if urgent:
                <table border="1">
                    <td align="center">
                        URGENT<br>
                        <br>
                        % for ticket_info in urgent:
                            <a href="http://localhost/rt/Ticket/Display.html?id={{ticket_info['id']}}">
                                {{ticket_info['subject']}}
                            </a>
                            % if username:
                            <a href="/ticket/{{ticket_info['id']}}/action/take?o={{username_id}}&email={{email}}">(take)</a>
                            % end
                        % end
                    </td>
                </table>
                <br>
                % end
                {{sum}}
            </td>
            <td>
                <table id="t01">
                    <tr>
                        <td id="header1" width="10%"> user </td>
                        <td id="header1" width="10%"> IN </td>
                        <td id="header1" width="10%"> ACTIVE </td>
                        <td id="header1" width="10%"> STALLED </td>
                        <td id="header1" width="10%"> REJECTED </td>
                        <td id="header1" width="10%"> DONE </td>
                    </tr>
                    % for email in sorted(summary):
                    %   if email.startswith('inbox'):
                    %       continue
                    %   end
                    %   user = email
                    %   if  email != 'unknown':
                    %       user = alias[email]
                    %   end
                    <tr>
                        <td><a id="header2" href="/detail/{{email}}?o={{username_id}}">{{user}}</a></td>
                        %   for status in ['new', 'open', 'stalled', 'rejected', 'resolved']:
                        <td align="center">{{summary[email][status]}}</td>
                        % end
                    </tr>
                    % end
                </table>
            </td>
        </tr>
    </table>
</body>