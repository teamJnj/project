package com.icia.jnj.test;

public class MoneyTest {
   public static void main(String[] args) {
     
     int sponG = 500000;   // 500,000
     int currentSponsorNo = 3; // 현재 후원 번호는 몇번?
     int sponM = 300000;    // 300,000
     
     int userM = 1300000;  // 1,300,000
      
      // 유기동물 후원 내역
      int result = (userM + sponM) / sponG;
      int resultM = (userM + sponM) % sponG;
      
      System.out.println("유기동물 후원 내역==========================");
      
      for( int i=currentSponsorNo; i<currentSponsorNo+result; i++){
         System.out.println( i+"회차 : 500,000원"  );
      }
      
      if( resultM > 0)
         System.out.println( (currentSponsorNo+result)+"회차 : " + resultM + "원" );
      
      if( resultM == 0)
         System.out.println( (currentSponsorNo+result)+"회차 : " + resultM + "원" );
      
      
      
      // 사용자 후원 내역
      System.out.println("사용자 후원 내역==========================");
      
      // 현재 회차에 남아 있는 돈이 얼만지 알아내면 그게 첫번째 후원 금액
      int useMoney = sponG-sponM;
      for( int i=currentSponsorNo; i<currentSponsorNo+result; i++)
      {
         if( i== currentSponsorNo )
            System.out.println( i+"회차 : " + useMoney + "원"  );
         else
            System.out.println( i+"회차 : 500,000원"  );
      }
      if( resultM > 0)
         System.out.println( (currentSponsorNo+result)+"회차 : " + resultM + "원" );
      if( resultM == 0)
         System.out.println( (currentSponsorNo+result)+"회차 : " + resultM + "원" );
      
   }
}