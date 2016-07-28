/**
 * Copyright (c) 2014, MK Partners, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of MK Partners, Inc. nor the names of its contributors
 *		nor the MKP Labs brand nor the www.mkpartners.com URL nor the www.mkplabs.com URL  
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

public with sharing class calloutViewer_Controller {
	
	public String requestEndpoint {get;set;}
	public String requestMethod {get;set;}
	public String requestBody {get;set;}
	public String responseStatus {get;set;}
	public Integer responseStatusCode {get;set;}
	public String responseBody {get;set;}
	public TestRestAPI.responseResource response {get;set;}
	public List<TestRestAPI.questionResource> deserializedQuestions {get;set;}
	
	public List<Child__c> childList = new List<Child__c>();
	
	public calloutViewer_Controller(){
		requestEndpoint = TestRestAPI.compileEndpoint(
			'questions/unanswered',
			'salesforce',
			1,
			50,
			system.today().addDays(-1),
			system.today(),
			'desc',
			system.today().addDays(-1),
			system.today(),
			'activity',
			''
		);
		
		childList = [SELECT id, Camping_Item__c, Points__c FROM Child__c];
	}

	public void callout(){
		httpResponse res = TestRestAPI.callout(requestMethod, requestEndpoint, requestBody);
		responseStatus = res.getStatus();
		responseStatusCode = res.getStatusCode();
		responseBody = res.getBody();
		
        System.debug('@@childList: '+childList);
		System.debug('@@responseBody: '+responseBody);
	}
	
	public void deserializeQuestions(){
		if ( string.isNotBlank(responseBody) ){
			response = (TestRestAPI.responseResource)JSON.deserialize(responseBody,TestRestAPI.responseResource.class);
			deserializedQuestions = response.items;
			
			//Added for testing purposes
            System.debug('@@childList: '+childList);
			System.debug('@@deserializedQuestions: '+'##'+ deserializedQuestions.size() + '##' +deserializedQuestions);
			
			Integer count = 0;
			for(TestRestAPI.questionResource rec: deserializedQuestions){
			    if(rec.view_count == 15){
			        count++;
			    }
			}
			System.debug('@@Count: '+count);
		}	
	}
	
	public List<SelectOption> getMethodOptions(){
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('GET','GET'));
		options.add(new SelectOption('POST','GET'));
		options.add(new SelectOption('PUT','GET'));
		options.add(new SelectOption('DELETE','GET'));
		options.add(new SelectOption('HEAD','GET'));
		return options;
	}
}