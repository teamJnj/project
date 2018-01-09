/*package com.icia.jnj.domain;

import java.util.ArrayList;
import java.util.List;
import com.icia.jnj.vo.GoodsOption;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class Basket {

	
	// 상품 정보입니다.
	private Integer 		goodsNo;
	private String 			goodsName;
	private Integer 		goodsPrice;
	private String 			goodsImg;
	
	// 여기에 넣을때는 인덱스 둘다 잘 맞춰줍니당ㅋ
	// 여기는 옵션 정보
	List<GoodsOption> 		optionList = new ArrayList<GoodsOption>();
	
	//새로운 공간에 값을 똑같이 복사하는 역할
	public List<GoodsOption> clone(List<GoodsOption> opList){
		optionList = new ArrayList<GoodsOption>();
		for( GoodsOption op : opList )
		{
			GoodsOption option = new GoodsOption();
			option.setGoodsNo(op.getGoodsNo());
			option.setOptionContent(op.getOptionContent());
			option.setOptionNo(op.getOptionNo());
			option.setQnt(op.getQnt());
			optionList.add(option);
		}
		return optionList;
	}
	
	
}*/
