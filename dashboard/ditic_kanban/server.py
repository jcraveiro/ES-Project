# -*- coding: utf-8 -*-
#
# By Pedro Vapi @2015
# This module is responsible for web routing. This is the main web server.
#
from time import time
from datetime import date
import os

from bottle import get
from bottle import post
from bottle import template
from bottle import request
from bottle import run
from bottle import redirect
from bottle import route
from bottle import static_file

from subprocess import call
import requests

from ditic_kanban.rt_summary import get_summary_info
from ditic_kanban.config import DITICConfig
from ditic_kanban.auth import UserAuth
from ditic_kanban.tools import user_tickets_details
from ditic_kanban.tools import ticket_actions
from ditic_kanban.tools import user_closed_tickets
from ditic_kanban.tools import search_tickets
from ditic_kanban.tools import get_urgent_tickets
from ditic_kanban.rt_api import RTApi
from ditic_kanban.statistics import get_date
from ditic_kanban.statistics import get_statistics

from rtkit.resource import RTResource
from rtkit.authenticators import CookieAuthenticator
from rtkit.errors import RTResourceError

from rtkit import set_logging
import logging

emailGlobal = ''

# My first global variable...
user_auth = UserAuth()

# Only used by the URGENT tickets search
my_config = DITICConfig()
system = my_config.get_system()
rt_object = RTApi(system['server'], system['username'], system['password'])

# This part is necessary in order to get access to sound files
# Static dir is in the parent directory
STATIC_PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), "../static"))
print STATIC_PATH


def create_default_result():
    # Default header configuration
    result = {
        'title': 'RT Dashboard'
    }

    call(["update_statistics"])
    call(["generate_summary_file"])

    # Summary information
    result.update({'summary': get_summary_info()})


    # Mapping email do uer alias
    config = DITICConfig()
    result.update({'alias': config.get_email_to_user()})

    return result


@get('/')
def get_root():

    start_time = time()

    result = create_default_result()
    # Removed to be a display at the TV
    #if request.query.o == '' or not user_auth.check_id(request.query.o):
    #    result.update({'message': ''})
    #    return template('auth', result)
    #result.update({'username': user_auth.get_email_from_id(request.query.o)})
    result.update({'username_id': request.query.o})
    today = date.today().isoformat()
    result.update({'statistics': get_statistics(get_date(30, today), today)})
    result.update({'summary': get_summary_info()})


    # Is there any URGENT ticket?
    result.update({'urgent': get_urgent_tickets(rt_object)})

    result.update({'time_spent': '%0.2f seconds' % (time() - start_time)})
    return template('entrance_summary', result)


@post('/auth')
def auth():

    result = create_default_result()
    result.update({'username': request.forms.get('username'), 'password': request.forms.get('password')})
    if request.forms.get('username') and request.forms.get('password'):
        try:
            if user_auth.check_password(request.forms.get('username'), request.forms.get('password')):
                redirect('/?o=%s' % user_auth.get_email_id(request.forms.get('username')))
            else:
                result.update({'message': 'Password incorrect'})
                return template('auth', result)
        except ValueError as e:
            result.update({'message': str(e)})
            return template('auth', result)
    else:
        result.update({'message': 'Mandatory fields'})
        return template('auth', result)


@get('/detail/<email>')
def email_detail(email):

        global emailGlobal
        emailGlobal = email
    	
        start_time = time()

        result = create_default_result()
        result2 = create_default_result()

        if request.query.o == '' or not user_auth.check_id(request.query.o):
            result.update({'message': ''})
            return template('auth', result)

        result.update({'username': user_auth.get_email_from_id(request.query.o)})
        result.update({'email': email})
        result.update({'username_id': request.query.o})


        result2.update(user_tickets_details(
            user_auth.get_rt_object_from_email(
                user_auth.get_email_from_id(request.query.o)
            ), "inbox"))


        result.update(user_tickets_details(
            user_auth.get_rt_object_from_email(
                user_auth.get_email_from_id(request.query.o)
            ), email))

        # Is there any URGENT ticket?
        result.update({'urgent': get_urgent_tickets(rt_object)})
        result.update({'summary': get_summary_info()})
        result.update({'time_spent': '%0.2f seconds' % (time() - start_time)})

        result2.update({'urgent': get_urgent_tickets(rt_object)})
        result2.update({'summary': get_summary_info()})
        result2.update({'time_spent': '%0.2f seconds' % (time() - start_time)})


        if email == 'inbox' or email == 'unknown':
            return template('ticket_list', result)
        else:
            return template('detail', result, tickets2 = result2)


@get('/closed/<email>')
def email_detail(email):


    start_time = time()

    result = create_default_result()
    if request.query.o == '' or not user_auth.check_id(request.query.o):
        result.update({'message': ''})
        return template('auth', result)

    result.update({'username': user_auth.get_email_from_id(request.query.o)})
    result.update({'email': email})
    result.update({'username_id': request.query.o})

    result.update(user_closed_tickets(
        user_auth.get_rt_object_from_email(
            user_auth.get_email_from_id(request.query.o)
        ), email))

    # Is there any URGENT ticket?
    result.update({'urgent': get_urgent_tickets(rt_object)})

    result.update({'summary': get_summary_info()})



    result.update({'time_spent': '%0.2f seconds' % (time() - start_time)})
    return template('ticket_list', result)


@post('/search')
def search():

    start_time = time()

    result = create_default_result()
    result2 = create_default_result()
    result3 = create_default_result()

    if request.query.o == '' or not user_auth.check_id(request.query.o):
        result.update({'message': ''})
        return template('auth', result)
    search = request.forms.get('search')



    result2.update(user_tickets_details(
        user_auth.get_rt_object_from_email(
            user_auth.get_email_from_id(request.query.o)
        ), "inbox"))

    result.update(search_tickets(
        user_auth.get_rt_object_from_email(
            user_auth.get_email_from_id(request.query.o)
        ), search))


    result3.update(user_tickets_details(
        user_auth.get_rt_object_from_email(
            user_auth.get_email_from_id(request.query.o)
        ), user_auth.get_email_from_id(request.query.o)))

    # Is there any URGENT ticket?
    result3.update({'urgent': get_urgent_tickets(rt_object)})
    result3.update({'summary': get_summary_info()})
    result3.update({'time_spent': '%0.2f seconds' % (time() - start_time)})

    result.update({'username': user_auth.get_email_from_id(request.query.o)})
    result.update({'email': search})
    result.update({'username_id': request.query.o})

    result.update({'summary': get_summary_info()})

    result2.update({'urgent': get_urgent_tickets(rt_object)})
    result2.update({'summary': get_summary_info()})
    result2.update({'time_spent': '%0.2f seconds' % (time() - start_time)})

    result.update({'urgent': get_urgent_tickets(rt_object)})
    result.update({'time_spent': '%0.2f seconds' % (time() - start_time)})

    #Vamos buscar os campos de Tickets de um determinado utilizador e fazemos merge
    res2 = result2['tickets']
    res3 = result3['tickets']
    allTickets = res2.copy()

    res2.clear()

    lst2 = filterTicketStatus(res3)

    lst = refineTicketSearch(allTickets, lst2, search)


    ticketsDic = dict()
    ticketsDic['tickets'] = lst

    return template('search', result, tickets2 = ticketsDic)

def filterTicketStatus(ticketStatus):

    lst = []

    for key, value in ticketStatus.items():
        for key2, value2 in value.items():
            for i in range(len(value2)):
                lst.append(value2[i])

    return lst


def refineTicketSearch(allTickets, ticket2,search):
    lst = []

    for key, value in allTickets.items():
            for i in range(len(value)):
                lst.append(value[i])


    for key, value in allTickets.items():
        for i in range(len(value)):
            for key2, value2 in value[i].items():
                if  search in value2:
                    lst.append(value[i])

    return lst

def refineTicketSearch(allTickets, ticket2,search):
    lst = []
    lst2 = []

    for key, value in allTickets.items():
            for i in range(len(value)):
                lst.append(value[i])

    for i in range(len(ticket2)):
        lst.append(ticket2[i])

    for i in range(len(lst)):
        for key, value in lst[i].items():
            if search in value:
                lst2.append(lst[i]);
                break


    return lst2



@route('/ticket/<ticket_id>/action/<action>')
def ticket_action(ticket_id, action):
    global emailGlobal
    ticketAction2(ticket_id, action)
    redirect("/detail/"+emailGlobal+"?o="+request.query.o)


def ticketAction2(ticket_id, action):


    start_time = time()

    result = create_default_result()
    result2 = create_default_result()


    if request.query.o == '' or not user_auth.check_id(request.query.o):
        result.update({'message': ''})
        return template('auth', result)

    # Apply the action to the ticket
    result.update(ticket_actions(
        user_auth.get_rt_object_from_email(
            user_auth.get_email_from_id(request.query.o)
        ),
        ticket_id,
        action,
        request.query.email, user_auth.get_email_from_id(request.query.o)
    ))

    # Update table for this user
    result.update(user_tickets_details(
        user_auth.get_rt_object_from_email(
            user_auth.get_email_from_id(request.query.o)
        ), request.query.email))

    result2.update(user_tickets_details(
        user_auth.get_rt_object_from_email(
            user_auth.get_email_from_id(request.query.o)
        ), "inbox"))


    result.update({'username': user_auth.get_email_from_id(request.query.o)})
    result.update({'email': request.query.email})
    result.update({'username_id': request.query.o})

    # Is there any URGENT ticket?
    result.update({'urgent': get_urgent_tickets(rt_object)})

    result.update({'summary': get_summary_info()})

    result.update({'time_spent': '%0.2f seconds' % (time() - start_time)})

    result2.update({'urgent': get_urgent_tickets(rt_object)})

    result2.update({'summary': get_summary_info()})


    result2.update({'time_spent': '%0.2f seconds' % (time() - start_time)})


    if request.query.email == 'inbox' or request.query.email == 'unknown':
        return template('ticket_list', result)
    else:
        return template('detail', result, tickets2 = result2)

@route("/static/<filepath:path>")
def static(filepath):
    return static_file(filepath, root=STATIC_PATH)

@get("/createTicket.html", method="GET")
def reroutePage():
    return template("createTicket")

@route("/createTicket.html", method="POST")
def createTicket():
    global emailGlobal

    priority = ''

    priority = int(request.forms.get('priority'))

    if priority >= 200:
        setUrgent = 'yes'
    else:
        setUrgent = ''

    set_logging('debug')
    logger = logging.getLogger('rtkit')

    my_config = DITICConfig()
    system = my_config.get_system()

    resource = RTResource('http://localhost/rt/REST/1.0/', system['username'], system['password'], CookieAuthenticator)

    #create a ticket
    content = {
        'content': {
            'Queue': request.forms.get("queue"), #General - unassigned is the name of the desired queue
            'Requestors': emailGlobal,
            'Subject' : request.forms.get("subject"), #text to go into subject field
            'Text': request.forms.get("content"),
            'Priority': request.forms.get('priority'),
            'CF.{servico}': request.forms.get("servico"),
            'CF.{IS - Informatica e Sistemas}': request.forms.get("inforsistemas"),
            'CF.{DITIC - Interrupted}': '',
            'CF.{DITIC - Urgent}': setUrgent,
            }
        }

    try:
        response = resource.post(path='ticket/new', payload=content,)
        logger.info(response.parsed)

    except RTResourceError as e:
        logger.error(e.response.status_int)
        logger.error(e.response.status)
        logger.error(e.response.parsed)



@route("/ticketDetails/<ticketID>", method="GET")
def modifyTicket(ticketID):
    global emailGlobal
    dic = {"email":emailGlobal}
    lst = []

    set_logging('debug')
    logger = logging.getLogger('rtkit')

    my_config = DITICConfig()
    system = my_config.get_system()

    resource = RTResource('http://localhost/rt/REST/1.0/', system['username'], system['password'], CookieAuthenticator)

    try:
        response = resource.get(path='ticket/'+ticketID)
        for r in response.parsed:
            for t in r:
                logger.info(t)
                lst.append(t)

    except RTResourceError as e:
        logger.error(e.response.status_int)
        logger.error(e.response.status)
        logger.error(e.response.parsed)

    lst = dict(lst)

    return template("ticketDetails", lst = lst, ticketID = ticketID, dic = dic)

@route("/addComment/<ticketID>", method="GET")
def reroutePage2(ticketID):
    return template("addComment", ticketID = ticketID)

@route("/addComment/<ticketID>", method="POST")
def addComment(ticketID):
    set_logging('debug')
    logger = logging.getLogger('rtkit')

    my_config = DITICConfig()
    system = my_config.get_system()

    resource = RTResource('http://localhost/rt/REST/1.0/', system['username'], system['password'], CookieAuthenticator)

    try:
        params = {
            'content' :{
                'Action' : 'comment',
                'Text' : request.forms.get("content"),
            },
        }

        params2 = {
            'content':{
                'status' : 'resolved',
            }
        }
        response = resource.post(path='ticket/'+ticketID+'/comment', payload=params,)
        response = resource.post(path='ticket/'+ticketID, payload=params2)
        for r in response.parsed:
           for t in r:
               logger.info(t)

    except RTResourceError as e:
        logger.error(e.response.status_int)
        logger.error(e.response.status)
        logger.error(e.response.parsed)

@route("/updateTicket/<ticketID>", method="POST")
def updateTicket(ticketID):
    global emailGlobal

    priority = int(request.forms.get('priority'))

    if priority > 255:
        priority = 255

    if priority >= 200:
        setUrgent = 'yes'
    else:
        setUrgent = ''

    set_logging('debug')
    logger = logging.getLogger('rtkit')

    my_config = DITICConfig()
    system = my_config.get_system()

    resource = RTResource('http://localhost/rt/REST/1.0/', system['username'], system['password'], CookieAuthenticator)

    #create a ticket
    content = {
        'content': {
            'Priority': str(priority),
            'cf.{ditic - urgent}': setUrgent,
            }
        }

    try:
        response = resource.post(path='ticket/'+ticketID, payload=content,)
        logger.info(response.parsed)

    except RTResourceError as e:
        logger.error(e.response.status_int)
        logger.error(e.response.status)
        logger.error(e.response.parsed)

@route("/logoutRest")
def logout():
    set_logging('debug')
    logger = logging.getLogger('rtkit')

    my_config = DITICConfig()
    system = my_config.get_system()

    resource = RTResource('http://localhost/rt/REST/1.0/', system['username'], system['password'], CookieAuthenticator)

    #create a ticket
    content = {
        'content': {}
    }

    try:
        response = resource.post(path='logout/', payload=content,)
        logger.info(response.parsed)

    except RTResourceError as e:
        logger.error(e.response.status_int)
        logger.error(e.response.status)
        logger.error(e.response.parsed)
    redirect("/")

@route("/archives.html/")
def archivedTickets():

    global emailGlobal
    email = emailGlobal

    start_time = time()

    result = create_default_result()

    if request.query.o == '' or not user_auth.check_id(request.query.o):
        result.update({'message': ''})
        return template('auth', result)

    result.update({'username': user_auth.get_email_from_id(request.query.o)})
    result.update({'email': email})
    result.update({'username_id': request.query.o})

    result.update(user_tickets_details(
        user_auth.get_rt_object_from_email(
            user_auth.get_email_from_id(request.query.o)
        ), email))

    # Is there any URGENT ticket?
    result.update({'urgent': get_urgent_tickets(rt_object)})
    result.update({'summary': get_summary_info()})
    result.update({'time_spent': '%0.2f seconds' % (time() - start_time)})

    result.update({'time_spent': '%0.2f seconds' % (time() - start_time)})


    return template('archive', result, tickets2 = result)



def start_server():
    run(server="paste",host='0.0.0.0',port=8080, interval=1, reloader=False, quiet=True)
