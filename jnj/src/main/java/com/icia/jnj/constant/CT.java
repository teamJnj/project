package com.icia.jnj.constant;

public class CT {
	
	
	public final static int MEMBER 							= 1;
	public final static int CENTER 							= 2;

	
	public final static int MEMBER_GRADE_GENERAL 			= 1;
	public final static int MEMBER_GRADE_BRONZE 			= 2;
	public final static int MEMBER_GRADE_SILVER 			= 3;
	public final static int MEMBER_GRADE_GOLD 				= 4;
	public final static int MEMBER_GRADE_PLATINUM 			= 5;
	public final static int MEMBER_GRADE_DIA 				= 6;

	public final static int MEMBER_STATE_BLOCK 				= 0;
	public final static int MEMBER_STATE_ENABLED 			= 1;
	public final static int MEMBER_STATE_ADMIN 				= 2;
	public final static int MEMBER_STATE_RESIGN				= 3;
	
	public final static int CENTER_STATE_BLOCK 				= 0;
	public final static int CENTER_STATE_ENABLED 			= 1;
	public final static int CENTER_STATE_JOIN_STANDBY 		= 2;
	public final static int CENTER_STATE_RESIGN_STANDBY 	= 3;
	public final static int CENTER_STATE_RESIGN				= 4;
	

	public final static int PET_GENDER_UNKNOWN		 		= 0;
	public final static int PET_GENDER_MALE 				= 1;
	public final static int PET_GENDER_FEMALE			 	= 2;
	
	
	
	public final static int PET_STATE_BLOCK 				= 0;
	public final static int PET_STATE_STANDBY 				= 1;
	public final static int PET_STATE_RECEIPT 				= 2;
	public final static int PET_STATE_PROCESS 				= 3;
	public final static int PET_STATE_ADOPT 				= 4;
	public final static int PET_STATE_MERCY 				= 5;
	
	
	
	public final static boolean ADOPT_CANCLE_NORMAILY 		= false;
	public final static boolean ADOPT_CANCLE_CANClE 		= true;
	
	
	
	public final static int MSPONSORRECORD_PAYWAY_CARD 		= 1;
	public final static int MSPONSORRECORD_PAYWAY_DEPOSIT	= 2;

	
	
	public final static int GOODS_STATE_SOLDOUT 			= 0;
	public final static int GOODS_STATE_SALES 				= 1;
	
	
	
	public final static int ORDERS_PAYWAY_CARD 				= 1;
	public final static int ORDERS_PAYWAY_DEPOSIT 			= 2;
	
	public final static int ORDERS_STATE_ORDER				= 1;
	public final static int ORDERS_STATE_DEPOSIT			= 2;
	public final static int ORDERS_STATE_STANDBY			= 3;
	public final static int ORDERS_STATE_DELIVERY			= 4;
	public final static int ORDERS_STATE_COMPLETE			= 5;
	
	
	
	public final static int ORDERECORD_STATE_ORDER				= 1;
	public final static int ORDERECORD_STATE_DEPOSIT			= 2;
	public final static int ORDERECORD_STATE_STANDBY			= 3;
	public final static int ORDERECORD_STATE_DELIVERY			= 4;
	public final static int ORDERECORD_STATE_COMPLETE			= 5;
	public final static int ORDERECORD_STATE_REFUNDING			= 6;
	public final static int ORDERECORD_STATE_REFUNDCOMPLETE		= 7;
	
	
	
	public final static int REFUND_RETURN						= 1;
	public final static int REFUND_CHANGE						= 2;
	
	
	
	public final static int VOLUNTEER_VOLUNTEERDIVISION_CENTER = 1;
	public final static int VOLUNTEER_VOLUNTEERDIVISION_MEMBER = 2;
	
	public final static int VOLUNTEER_VOLUNTEERSTATE_BLOCK = 0;
	public final static int VOLUNTEER_VOLUNTEERSTATE_RECURIT = 1;
	public final static int VOLUNTEER_VOLUNTEERSTATE_COMPLETE = 2;
	
	
	
	public final static int VOLUNTEERAPPLY_VOLUNTEERAPPLYSTATE_CANCLE = 0;
	public final static int VOLUNTEERAPPLY_VOLUNTEERAPPLYSTATE_RECURIT = 1;
	public final static int VOLUNTEERAPPLY_VOLUNTEERAPPLYSTATE_COMPLETE = 2;
	public final static int VOLUNTEERAPPLY_VOLUNTEERAPPLYSTATE_LACK = 3;
	
	
	
	public final static int MARKET_MARKETSTATE_RECURIT = 1;
	public final static int MARKET_MARKETSTATE_COMPLETE = 2;
	
	
	public final static int MARKETAPPLY_PAYWAY_CARD = 1;
	public final static int MARKETAPPLY_PAYWAY_DEPOSIT = 2;
	
	public final static int MARKETAPPLY_MARKETAPPLYSTATE_CANCLE = 0;
	public final static int MARKETAPPLY_MARKETAPPLYSTATE_APPLY = 1;
	public final static int MARKETAPPLY_MARKETAPPLYSTATE_COMPLETE = 2;
	public final static int MARKETAPPLY_MARKETAPPLYSTATE_LACK = 3;
	
	
	
	public final static int FIND_FINDDIVISION_FIND = 1;
	public final static int FIND_FINDDIVISION_FOUND = 2;
	
	public final static int FIND_PETGENDER_UNKNOWN = 0;
	public final static int FIND_PETGENDER_MALE = 1;
	public final static int FIND_PETGENDER_FEMALE = 2;
	
	public final static int FIND_FINDSTATE_BLOCK = 0;
	public final static int FIND_FINDSTATE_ENABLED = 1;
	
	
	
	public final static int FINDCOMMENT_FINDDIVISION_FIND = 1;
	public final static int FINDCOMMENT_FINDDIVISION_FOUND = 2;
	
	
	
	public final static int QNA_QNADIVISION_CENTER = 1;
	public final static int QNA_QNADIVISION_MEMBER = 2;
	
	public final static int QNA_SORT_SPONSOR = 1;
	public final static int QNA_SORT_ADOPT = 2;
	public final static int QNA_SORT_VOLUNTEER = 3;
	public final static int QNA_SORT_MARKET = 4;
	public final static int QNA_SORT_STORE = 5;
	public final static int QNA_SORT_BOARD = 6;
	public final static int QNA_SORT_ECT = 7;
	
	
	
}
