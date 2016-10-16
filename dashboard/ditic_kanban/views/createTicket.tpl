

<style>
body {
    background-color:#eeeeee;
    font-family: "Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;
    color:#555;
}


#header{
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
    margin-top: 3%;
    font-weight: 500;
}

.input{
    border-style:solid;
    box-sizing: padding-box;
    padding: 6px 20px 4px 20px;
    
}
.caixa{
    width: 30%;
    box-sizing: padding-box;
    padding: 6px 20px 4px 20px;
}

.coment{
    resize: none;
    border-style:solid;
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

<body>
        <div id="header">
            <div align="right">
                <img src="https://www.it.pt/img/partners/UCoimbra-Logo-cinza.png" width="150px" >  
        </div>
        <div id="title">
            <p>Create Ticket</p>    
        </div>
        </div>

        <form action="/createTicket.html" onSubmit="window.opener.location.reload(true);window.close();" method="post">
        <table align="center" >
            <tr>
                <td>
                    <table align="right" >
                        <tr align="right" >
                            <td>
                                <label class="caixa" for="label1">Queue</label><input class="input" size="40" id="input1" name="queue" >
                            </td>   
                        </tr>
                        <tr align="right">
                            <td>
                                <label class="caixa" for="label2">Servico</label><input class="input" size="40" id="input2" name="servico" >
                            </td>   
                        </tr>
                        <tr align="right">
                            <td>
                                <label class="caixa" for="label3">IS - Informatica e Sistemas</label><input class="input" size="40" id="input3" name="inforsistemas" >
                            </td>   
                        </tr>
                        <tr align="right">
                            <td>
                                <label class="caixa" for="label4">Subject</label><input class="input" size="40" id="input4" name="subject" >
                            </td>   
                        </tr>
                          
                        <tr align="right" class="caixa">
                            <td>
                                <label class="caixa" for="label3">Priority</label><input class="input" size="1" id="input5" name="priority" type="number" min="0" max="255" value="25" >
                            </td>   
                        </tr>

                    </table>
                </td>
            </tr>
            
            
            <tr>
                <td>
                    <label align="left" for="label5">Content</label>
                    <p></p>
                    <textarea class="coment" align="center" name="content" ></textarea>
                </td>
            </tr>
            
            <tr align="right">
                <td>
                    <button class="botao" type="submit">Create Ticket</button>
                </td>
            </tr>
        </table>
    </form>

    </body>