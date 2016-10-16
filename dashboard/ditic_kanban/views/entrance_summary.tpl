<!---code taken from http://www.w3schools.com/bootstrap/bootstrap_case_navigation.asp -->

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

    body {
        background-color: #eeeeee;
        font-family: Arial;
        min-width: 800px;
    }

  
    table#t02 { 
        background-color: #FFFFFF;
        margin-left: 10px;
        box-shadow: 2px 2px 1px #b6b6b6;
    }

    table#t01 tr:nth-child(odd) td{
    }
    table#t01 tr:nth-child(even) td{
        background-color:   #e6e6e6;
    }

    #submenu{
        background-color: #4d4d4d;
        color: #dd890b;
        font-weight: bold;
    }


    .navbar{
        background-color: #3c3c3c;
        box-shadow: 0px 3px 1px #b6b6b6;
        border: none;
        border-radius: 0px;
    }



</style>

<nav id="n1" class="navbar navbar-default">
  <div class="container-fluid">
    <div class="navbar-header">
      <a id="text" class="navbar-brand">RT Dashboard</a>
    </div>
    <div>
      <ul class="nav navbar-nav">
        <li id="submenu" class="active"><a id="submenu" href="/?o={{username_id}}">Home</a></li>
      </ul>
    </div>
  </div>
</nav>

<body>

% result = "['Date', 'Created', 'Resolved', 'Still open'],\n"
% for day in sorted(statistics):
%   if statistics[day]:
%       result += '''["%s", %s, %s, %s],\n''' % (day,
%                                              statistics[day]["created_tickets"],
%                                              statistics[day]['team']['resolved'],
%                                              statistics[day]['team']['open'])
%   else:
%       result += '["%s", 0, 0, 0],\n' % day
%   end
% end

% graph_script = """
<td align="right">
    <script type="text/javascript"
          src="https://www.google.com/jsapi?autoload={
            'modules':[{
              'name':'visualization',
              'version':'1',
              'packages':['corechart']
            }]
          }"></script>

    <script type="text/javascript">
      google.setOnLoadCallback(drawChart);

      function drawChart() {
        var data = google.visualization.arrayToDataTable([
%s
        ]);

        var options = {
          title: 'Número de tickets',
          curveType: 'function',
          legend: { position: 'bottom' },
          backgroundColor: { fill:'transparent' }
        };

        var chart = new google.visualization.LineChart(document.getElementById('performance'));

        chart.draw(data, options);
      }
    </script>
""" % result

% result = "['Date', 'Mean Time to Resolve', 'Time worked'],\n"
% for day in sorted(statistics):
%   if statistics[day]:
%       result += '''["%s", %s, %s],\n''' % (day,
%                                      statistics[day]['team']['mean_time_to_resolve']/60,
%                                      statistics[day]['team']['time_worked']/60)
%   else:
%       result += '["%s", 0, 0],\n' % day
%   end
% end
% graph_script += """
 <script type="text/javascript"
          src="https://www.google.com/jsapi?autoload={
            'modules':[{
              'name':'visualization',
              'version':'1',
              'packages':['corechart']
            }]
          }"></script>

    <script type="text/javascript">
      google.setOnLoadCallback(drawChart);

      function drawChart() {
        var data = google.visualization.arrayToDataTable([
%s
        ]);

        var options = {
          title: 'Tempo médio de resolução vs Tempo total trabalhado (horas)',
          curveType: 'function',
          legend: { position: 'bottom' },
          backgroundColor: { fill:'transparent' },
        };

        var chart = new google.visualization.LineChart(document.getElementById('mean_time_to_resolve'));

        chart.draw(data, options);
      }
    </script>
""" % result

% rebase('skin', meta_refresh=300)

<p>
    % username = get('username', '')
    % if username:
    <strong>Authenticated as: {{username}}</strong>
    % end
</p>

<table id="t02" border="1" align="left" valign="bottom" width="35%">
    <tr>
        <td ><a id="header2" href="/detail/inbox?o={{username_id}}">INBOX</a></td>
        <td id="header1">DITIC Kanban Board</td>
    </tr>
    <tr>
        % # INBOX
        % sum = 0
        % # we need this code because INBOX can have tickets all along several status
        % for status in summary['inbox']:
        %   sum += summary['inbox'][status]
        % end
        <td align="center" valign="top">{{sum}}</td>
        <td >
            <table id="t01">
                <tr>
                    <td id="header1" width="10%"> user </td>
                    <td id="header1" width="10%"> IN </td>
                    <td id="header1" width="10%"> ACTIVE </td>
                    <td id="header1" width="10%"> STALLED </td>
                    <td id="header1" width="10%"> REJECTED </td>
                    <td id="header1" width="10%"> DONE </td>
                 </tr>
                % totals = { status: 0 for status in ['new', 'open', 'stalled', 'rejected', 'resolved']}
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
                    %       totals[status] += summary[email][status]
                    % end
                </tr>
                % end
                <tr>
                    <td><strong>Totais</strong></td>
                    %   for status in ['new', 'open', 'stalled', 'rejected', 'resolved']:
                    <td align="center"><strong>{{totals[status]}}</strong></td>
                    % end
                </tr>
            </table>
        </td>
    </tr>
</table>

<table border="0" align="right">
    <td valign="top">
        <td>
            <div id="performance" style="width: 400px; height: 400px"></div>
        </td>
        <td>
            <div id="mean_time_to_resolve" style="width: 400px; height: 400px"></div>
        </td>
    </td>

</table>

</body>
