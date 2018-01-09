package com.icia.jnj.test;

import java.util.ArrayList;
import java.util.List;


public class MoneyTest2 {
   public static void main(String[] args) {

	 List<Integer> list = new ArrayList<Integer>();
	 int pet1 = 800000; // 안락사 순위기준 50만원-현재 후원금액(전체후원금액/50만원의 나머지)
     int pet2 = 200000;	// select * from pet order by mercy_date asc; 순서
     int pet3 = 900000;
     int pet4 = 550000;
     int pet5 = 30000;
     int pet6 = 50000;
     
     list.add(pet1);
     list.add(pet2);
     list.add(pet3);
     list.add(pet4);
     list.add(pet5);
     list.add(pet6);
     
     
	 
	 int allMoney = 1000000;   // 상태 4, 5인 애들의 총 금액
     
	 int sponG = 500000;   // 500,000
     
     // 만약 amAllMoney가 pet이 필요한 돈보다 적을 때
     // 남은돈(restMoney)을 마지막 pet한테 더해주고 계산끝
     
     System.out.println("자이제 시작이야....==========================");
     
     for(int i=0; i<list.size(); i++) {
    	 int nowSponM = (list.get(i)) % sponG;	// 현재 pet에게 있는 돈
    	 int needM = sponG-nowSponM;
    	 
    	 allMoney = allMoney-needM;
    	 
    	 
    	 System.out.println( i+"회차 : " + allMoney + "원 남았음"  );
    	 if(allMoney>0){
    		 // 업데이트: 현재pet(pet_no)의 sponsor_money에 needM더한 값만큼으로 세팅
    		 System.err.println( i+"회차 : " + nowSponM + "원 더하기"+ needM );
    		 System.err.println( i+"회차 디비 업데이트 : " + list.get(i) + "원 더하기"+ needM );
    		 
    	 } 
    	 
    	 if(allMoney==0 || allMoney<0) {
    		 // 업데이트: 현재pet(pet_no)의 sponsor_money에 allMoneyResult를 업데이트하는 문구
    		 int resultSponM = needM + allMoney;
    		 System.out.println( i+"회차 : " + resultSponM + "원은 최종!!!"  );
    		 System.err.println( i+"회차 디비 업데이트 : " + list.get(i) + "원 더하기"+ resultSponM +"최종값 :"+(list.get(i)+resultSponM));
    		 break;
    	 }
    	 
     }
    
   }
}