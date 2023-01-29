@isTest
public with sharing class MockHttpResponseGenerator implements HttpCalloutMock{
    
    public HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('https://api.openai.com/v1/completions', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());

        HTTPResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"id":"cmpl-6cYIagtiL8GfocKxbu6DG2Cw8Algm","object":"text_completion","created":1674646328,"model":"text-davinci-003","choices":[{"text":"Test Response","index":0,"logprobs":null,"finish_reason":"stop"}],"usage":{"prompt_tokens":16,"completion_tokens":2,"total_tokens":18}}');
        res.setStatusCode(200);
        return res;

    }
    
}