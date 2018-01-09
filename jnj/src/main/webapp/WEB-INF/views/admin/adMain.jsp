<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>     
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>관리자 메인</title>
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	<script type="text/javascript">
		google.charts.load('current', {'packages':['corechart']});
		google.charts.setOnLoadCallback(drawVisualization);
	
		function drawVisualization() { 
			var data = google.visualization.arrayToDataTable([
					['후원', '매출', { role:'style'}],
					['8',  8.94, 'skyblue' ],
					['9',  10.94, 'silver' ],
					['10',  19.94, 'gold' ],
					['11',  21.94, 'color:#eaeaea' ],
				]);
			
			var options = {
					title : '후원 현황',
					width : 700,
					height : 450
				};
			
			
			var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
			google.visualization.events.addListener(chart, 'select', selectHandler);
			chart.draw(data, options);
		}
		
		function selectHandler(){
			var selectedItem = chart.getSelection()[0];
			var name = chart.getValue(selectedItem.row, 0);
			var value = chart.getValue(selectedItem.row, 1);
			alert( name + " 선택 : " + value);
		}
	</script>

</head>
<body>
	
	<div class="content-wrapper">
    	<div class="container-fluid">
    	
	    	<div class="card mb-3">
            	<div class="card-header">
            		<i class="fa fa-bar-chart"></i>
            		Bar Chart Example
            	</div>
            	<div class="card-body">
	    			<div id="chart_div" style="width:900px; height: 500px;"></div>
	    		</div>
	    	</div>
	    	
		</div>
    </div>
    
    
    
      
</body>
</html>