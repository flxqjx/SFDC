public with sharing class StudentController {
		public List<Student__c> sduentList{get;set;}
		public List<SelectOption> sexTypes = new List<SelectOption>();
		public List<SelectOption> educationTypes= new List<SelectOption>();
		public Student__c student{get;set;}
		public string name{get;set;}
		public string birthdayStart{get;set;}
		public string birthdayEnd{get;set;}
		public String sexType{get;set;}
		public String educationType{get;set;}
		public StudentController() {
			sduentList = new List<Student__c>();
			refreshData();
		}
		public List<SelectOption> getSexTypes() {
			sexTypes.clear();
			sexTypes.add(new SelectOption('男','男'));
			sexTypes.add(new SelectOption('女','女'));
			return sexTypes;
		}
		public List<SelectOption> getEducationTypes() {
			educationTypes.clear();
			educationTypes.add(new SelectOption('小学','小学'));
			educationTypes.add(new SelectOption('初中','初中'));
			educationTypes.add(new SelectOption('高中','高中'));
			educationTypes.add(new SelectOption('专科','专科'));
			educationTypes.add(new SelectOption('本科','本科'));
			educationTypes.add(new SelectOption('硕士','硕士'));
			educationTypes.add(new SelectOption('博士','博士'));
			educationTypes.add(new SelectOption('文盲','文盲'));
			return educationTypes;
		}
	 //刷新数据作用
		public void refreshData() {
			String queryString = 'SELECT ID,Name,Education__c,Sex__c,birthday__c FROM  Student__c where IsDeleted=false limit 100';
			sduentList = Database.query(queryString);
		}
		public void save() {
			try {
				upsert sduentList;
			} catch(DmlException e) {
				ApexPages.addMessages(e);
			}
		}
		public void deleteStu() {
			Id id = ApexPages.currentPage().getParameters().get('stuId');
			Database.delete(id);
			refreshData();
		}
		public void add() {
			if(sduentList == null) {
				sduentList = new List<Student__c>();
			}
			Student__c stuNew = new Student__c();
			if(sduentList.size() == 0) {
				sduentList.add(stuNew);
			} else {
				sduentList.add(0,stuNew);
			}
		}
		public void query() {
			String querySql = 'SELECT ID,Name,Education__c,Sex__c,birthday__c FROM  Student__c where IsDeleted=false';
			if(name.length() >0) {
				name = '%' + name + '%';
				querySql += ' and name like :name ';
			}
			if(sexType.length() > 0) {
				sexType = '%' + sexType + '%';
				querySql += ' and Sex__c like :sexType';
			}
			if(educationType.length() > 0) {
				educationType = '%' + educationType + '%';
				querySql += ' and Education__c like :educationType';
			}

			if(birthdayStart.length()>0) {
				querySql += ' and birthday__c >= :birthdayStart';
			}
			if(birthdayEnd.length()>0) {
				querySql += ' and birthday__c <= :birthdayEnd';
			}
			querySql += ' limit 100';
			sduentList = Database.query(querySql);
			name = name.remove('%');
			sexType = sexType.remove('%');
			educationType = educationType.remove('%');
		}
	}