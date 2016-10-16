
<style>
    #bd1{
        background-color: #eeeeee;
    }

    table{
      background-color: #3c3c3c;
      text-align: center;
      font-weight: bold;
      font-family: "Helvetica Neue", Helvetica;
    }

    .botao{
	    font-weight: 200;
	    border: none;
	    background-color:white;
	    box-shadow: 2px 2px 1px #b6b6b6;
	}   
</style>

<body id="bd1">
    <table width="100%" height="100%" align="left" border="2">
    	<tr>
    		<td style="color: #dd890b;">Ticket Details</td>
    	</tr>
        % for key, value in lst.items():
        <tr>
            <td align="left" valign="center" style="color:  #eeeeee;" colspan="2">
            	% if key != 'Priority':
                	{{key}}: {{value}}
                % end
                % if key == 'Priority' and lst['Owner'] == dic['email']:
	                <form action="/updateTicket/{{ticketID}}" onSubmit="window.opener.location.reload(true);window.close();"method="post">
	                	Priority:<input name="priority" width="100%" value="{{value}}">&nbsp;&nbsp;<button class="botao" align="right" type="submit">Update Priority</button>
	                </form>
	            % end
	            % if key == 'Priority' and lst['Owner'] != dic['email']:
	            	{{key}}: {{value}}
                % end
            </td>
        </tr>
        % end
    </table>
</body>