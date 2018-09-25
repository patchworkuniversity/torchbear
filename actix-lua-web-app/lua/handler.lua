local utils = require "utils.utils"
local luvent = require "utils.Luvent"
local test_client_action = require "actions.test-client"
local debug_action = require "actions.debug"
local post_document_action = require "actions.post_document"
local get_document_action = require "actions.get_document_by_type"
local get_documents_action = require "actions.get_documents_by_type"

local req = ctx.msg -- get the request
local response -- declare the response

local action_debug
local action_test_client
local action_post
local action_get_docs
local action_get_doc

reqProcess = luvent.newEvent() -- create event for request processing

-- declare and add actions

action_debug = reqProcess:addAction( 
    function(req)
        debug_action.action(req)
    end
)
action_test_client = reqProcess:addAction( -- 
    function(req)
       response = test_client_action.action(req)
    end
)
action_post = reqProcess:addAction(
    function(req)
        response = post_document_action.action(req)
    end
)
action_get_doc = reqProcess:addAction(
    function(req)
        response = get_document_action.action(req) -- this is for /post/something
    end
)
action_get_docs = reqProcess:addAction(
    function(req)
        response = get_documents_action.action(req) --this is for /post
    end
)

reqProcess:setActionPriority(action_get_doc, 1)
reqProcess:setActionPriority(action_get_docs, 9)
reqProcess:setActionPriority(action_post, 2)
reqProcess:setActionPriority(action_test_client, 10)
reqProcess:setActionPriority(action_debug, 6)



-- end of declaring actions

-- try/catch in case of errors 

utils.try(function()
    
    reqProcess:trigger(req) -- try to process request and give response

end, function(err)
    print(err)
    response = { 
        status = 500,
         body = '{ "error": ' .. "try-catch error" .. ' }',  -- if something go wrong give error 500 in response
    }
end)


return response

