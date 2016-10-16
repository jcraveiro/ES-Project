
<style>
body {
    background-color:#eeeeee;
    font-family: "Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;
    color:#555;
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

#title{
    font-size:large;
    color: #dd890b; 
    font-weight: bold;
    margin-top: -70px;
    /*Altera a posição do titulo na janela*/
    margin-left: 20px;
}

form{
    margin-top: 30px;
    font-weight: 600;
}

.coment{
    resize: none;
    border-style:none;
    box-sizing: padding-box;
    padding: 6px 20px 4px 20px;
    height:200px;
    width:600px;
}

.botao{
    width: 20%;
    font-weight: 200;
    border: none;
    background-color:white;
    box-shadow: 2px 2px 1px #b6b6b6;
}
</style>

<body id="bd1">
    
    <div width="" id="header">
        <div align="right">
            <img src="https://www.it.pt/img/partners/UCoimbra-Logo-cinza.png" width="150px" >  
        </div>
        <div id="title">
            <p>Add Comment</p>  
        </div>
    </div>
        
        
    <form action="/addComment/{{ticketID}}" onSubmit="window.opener.location.reload(true);window.close();" method="post">
        <table align="center" valign="center">            
            <tr>
                <td>
                    <label id="lb1" align="left" for="label5">Give a reason for the closing of the ticket:</label>
                    <p></p>
                    <textarea align="left" class="coment" style="height:200px;width:500px;" name="content" ></textarea>
                </td>
            </tr>
            
            <tr align="left">
                <td>
                    <button class="botao" type="submit">Add Comment</button>
                </td>
            </tr>
        </table>
    </form>
</body>