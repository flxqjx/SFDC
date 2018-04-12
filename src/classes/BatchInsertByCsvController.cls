public with sharing class BatchInsertByCsvController {
    public string fileName{get;set;}
    public Blob contentFile{get;set;}
    String[] filelines = new String[]{};
    public List<Vendor__c> vendorList;
    
    public Pagereference ReadFileAndOperate()
    {
        try{        
            fileName =bitToString( contentFile,'ISO-8859-1');           
            filelines = fileName.split('\n');            
            vendorList = new List<Vendor__c>();
            for (Integer i=1;i<filelines.size();i++)
            {
                String[] inputvalues = new String[]{};
                inputvalues = filelines[i].split(',');
                Vendor__c vendor = new Vendor__c();
                vendor.Vendor_Code__c = inputvalues[0];
                vendor.Vendor_Code_EN__c = inputvalues[1];
                vendor.Vendor_Name__c = inputvalues[2];
                vendorList.add(vendor);
            }
         }
         catch(Exception e){
                 ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured reading the CSV file'+e.getMessage());
                 ApexPages.addMessage(errormsg);
         }       
        try{
            insert vendorList;
            ApexPages.Message successMsg = new ApexPages.Message(ApexPages.severity.INFO,'import success');
            ApexPages.addMessage(successMsg);
        }
        catch (Exception e)
        {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured inserting the records'+e.getMessage());
            ApexPages.addMessage(errormsg);
        }
        return null;
    }
   
    public List<Vendor__c> getuploadedVendors()
    {
        if (vendorList!= null) {
            if (vendorList.size() > 0) {
                return vendorList;
            } else{
                return null;                    
            }
        }else 
        {
            return null;
        }
    }  
       
    public static String bitToString(Blob input, String inCharset){
        //转换成16进制
        String hex = EncodingUtil.convertToHex(input);
        //一个String类型两个字节 32位（bit）,则一个String长度应该为两个16进制的长度，所以此处向右平移一个单位，即除以2
        //向右平移一个单位在正数情况下等同于除以2，负数情况下不等
        //eg 9  00001001  >>1 00000100   结果为4
        final Integer bytesCount = hex.length() >> 1;
        //声明String数组，长度为16进制转换成字符串的长度
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i) {
            //将相邻两位的16进制字符串放在一个String中
            bytes[i] =  hex.mid(i << 1, 2);
        }
        //解码成指定charset的字符串
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }
}