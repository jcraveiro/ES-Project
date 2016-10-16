<script>
function res(str) {
    if(str!=""){
        alert(str);
    }
}
</script>

% rebase('skin')
<style>
    
    body {
    background-color:#eeeeee;
    font-family: "Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;
    color:#555;

}
#header{
    margin:-10px;
    background-color: #3c3c3c;
    padding-bottom: 1px;
    font-family: "Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;
    font-size: large;
    color: #dd890b; 
    font-weight: 200;
    box-shadow: 0px 3px 1px #b6b6b6;
 
    
}

label {
    display: inline-block;
    max-width: 100%;
    margin-bottom: 5px;
    font-weight: 700;
   
}

form{
    margin-top: 3%;

}
    
.botao{
    width: 100%;
    margin-top: 10px;
    font-weight: 100;
    border: none;
    background-color:white;
    box-shadow: 2px 2px 1px #b6b6b6;
}

.caixa{
    width: 100%;
    border-style:solid;
    box-sizing: padding-box;
    padding: 6px 10px 6px 10px;
    
    
}
.cabecalho{
    text-align: left;
    padding-top: 15px;
    
}

</style>
<body>
    <div id="header" align="center">
                <img src="http://localhost:8080/static/Images/uc.png" width="25%" >  
                <p>Helpdesk</p>
    </div> 
        <form action="/auth" onSubmit="res('{{message}}');" method="post">
            <table align="center">
                <tr>
                    <td>
                        <label class="cabecalho" for="exampleInputEmail3">Username</label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <input class="caixa" align="right" name="username" type="text" value="{{get('username', '')}}"/>
                    </td>
                </tr>            
            <tr>
                <td>
                    <label class="cabecalho" for="exampleInputPassword3">Password</label></br>
                </td>
            </tr>
            <tr>
                <td>
                    <input class="caixa" size="20" name="password" type="password" value="{{get('password', '')}}" />
                </td>
            </tr>
            <tr>
                <td>
                    <button class="botao" value="Login" type="submit">Login</button>
                </td>
            </tr>
            </table>
        </form>
</body>