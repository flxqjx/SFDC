@isTest
private class Test {
    static testMethod void testMethod1() {
		String queryString = 'SELECT   Name,Education__c,Sex__c,ScoreID__r.Score__c ,ScoreID__r.Name  FROM  Student__c';
		List<Student__c> prs = Database.query(queryString);
		String queryJson = JSON.serialize(prs);
		System.debug(queryJson);

		//获取SObject的token
        //1、先获取所有token,然后通过key获取需要的token
        //2、直接获取指定的sObject的token
        
        //1、通过获取全部描述信息，然后get方法获取需要的指定字段的描述信息
        Map<String,Schema.SObjectType> allSObjectTypeDescribes = Schema.getGlobalDescribe();
        Schema.SObjectType merchandiseType1 = allSObjectTypeDescribes.get('Student__c');
        
        //2、直接获取指定sObject的token
        Schema.SObjectType merchandiseType2 = Student__c.SObjectType;
        System.debug(merchandiseType2);

        /*
         * 获取Schema.DescribeSObjectResult
         * 1、通过token的getDescribe方法**/
        Schema.DescribeSObjectResult merchandiseResult = merchandiseType1.getDescribe();
        System.debug(merchandiseResult);
        System.debug(merchandiseResult.getLabel());
        System.debug('sObject的API的名称为' + merchandiseResult.getName());
        System.debug('Student表是否为自定义的Object ：' + (merchandiseResult.isCustom() ? '是':'否'));   


        /*
         * 2、通过System命名空间下的Schema的方法
         * */
        List<String> sObjectTypes = new String[]{'Student__c'};
        List<Schema.DescribeSObjectResult> merchandiseResult1 = Schema.describeSObjects(sObjectTypes);
        System.debug(merchandiseResult1[0].getLabel());
        System.debug('sObject的API的名称为' + merchandiseResult1[0].getName());
        System.debug('Student表是否为自定义的Object ：' + (merchandiseResult1[0].isCustom() ? '是':'否'));   

        //---------------------------------------//
        List<Schema.ChildRelationship> childRelationResult = merchandiseResult.getChildRelationships();
        for(Schema.ChildRelationship child : childRelationResult){
            System.debug('Student子Object的关联名称:'+ child.getRelationshipName());
        }

        /**
         * 以下操作位获取field的元信息结果，以Education__c为例
         * 两种操作方式：
         * 1、通过DescribeSObjectResult的fields方法获取token,然后再通过getDescribe方法获取
         * 2、直接获取字段然后使用getDescribe方法
         * */
        Map<String,SObjectField> sObjectFieldMaps = merchandiseResult.fields.getMap();
        SObjectField educationField = sObjectFieldMaps.get('Education__c');
        Schema.DescribeFieldResult educationFieldResult = educationField.getDescribe();
        Schema.DisplayType educationType = educationFieldResult.getType();
        System.debug('education字段类型为:'+educationType);
        System.debug('education字段API名称为:'+educationFieldResult.getName());
        System.debug('education字段label名称为:'+educationFieldResult.getLabel());
        //------------------------------//
        List<Schema.PicklistEntry> educationListValues = educationFieldResult.getPicklistValues();
        Map<String,Object> educationListValueMap = new Map<String,Object>();
        for(Schema.PicklistEntry educationListItem : educationListValues){
            educationListValueMap.put(educationListItem.getValue(),new Map<String,Object>{
                'value'=>educationListItem.getValue(),'label'=>educationListItem.getLabel()
            });
        }
        System.debug(educationListValueMap);

        
    }
    
}