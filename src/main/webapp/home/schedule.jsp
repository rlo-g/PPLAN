<%@page import="com.model.MemberDTO"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="list.model.PlaceDTO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.controller.SegmentedPaths"%>
<%@page import="com.controller.TSPSolver"%>
<%@page import="list.model.ListDAO"%>

<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
   pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<!--
   Helios by HTML5 UP
   html5up.net | @ajlkn
   Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)
-->
<html>
<head>
<title>��������</title>
<meta charset="utf-8" />
<meta name="viewport"
   content="width=device-width, initial-scale=1, user-scalable=no" />
<link rel="stylesheet" href="assets/css/sche.css" />
<noscript>
   <link rel="stylesheet" href="assets/css/noscript.css" />
</noscript>
<script type="text/javascript"
   src="//dapi.kakao.com/v2/maps/sdk.js?appkey=17ef75805e870442ce556e97240445b9"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body class="left-sidebar is-preload">
<%
         MemberDTO info = (MemberDTO)session.getAttribute("info");
      %>
   <div id="page-wrapper">

      <!-- Header -->
      <div id="header">

         <!-- Inner -->
         <div class="inner">
            <header>
               <h1>
                  <a href="main.jsp" id="logo">Pplan</a>
               </h1>
            </header>
         </div>

         <!-- Nav -->
         <nav id="nav">
              <ul>
                        <li><a href="main.jsp">Home</a></li>
                        <li><a href="recommend.jsp">��õ����</a></li>
                        <li><a href="../game1/game.jsp">�����ϱ�</a></li>
                        <%if(info != null){ %>
                           <li><a href="menuMyPage.jsp">����������</a></li>
                           <li><a href="../LogoutService">�α׾ƿ�</a></li>
                        <%}else{%>
                        <li><a href="login/login.jsp">�α���</a></li>
                        <%} %>
                     </ul>
         </nav>

      </div>


      <%
      // ���޵� �迭 �ޱ�
      String[] dataArray = request.getParameterValues("dataArray");
      String placeStr = "";
      ListDAO dao = new ListDAO();
      ArrayList<PlaceDTO> daoArr = new ArrayList<>();

      if (dataArray != null) {
         for (int i = 0; i < dataArray.length; i++) {
            PlaceDTO selectedDTO = dao.selectedPlaceGet(Integer.parseInt(dataArray[i]));
            daoArr.add(selectedDTO);
         }

         /*             out.println("<h1>���� ���� placeNum�� :</h1>");
                     out.println("<ul>");v
                     for (String value : dataArray) {
         out.println("<li>" + value + "</li>");
                     }
                     
                    for(PlaceDTO dto : daoArr){
                       out.println("<li>" + "<img src = \""+dto.getPlace_img()+"\">" + "</li>");
                    }
                     out.println("</ul>"); */
      } else {
         out.println("<h1>No Array Data Received</h1>");
      }
      Map<String, double[]> points = new HashMap<>();
      for (PlaceDTO dto : daoArr) {
         points.put(dto.getPlace_name(),
         new double[]{Double.parseDouble(dto.getPlace_latitude()), Double.parseDouble(dto.getPlace_longitude())});

      }
      TSPSolver tspSolver = new TSPSolver();
      SegmentedPaths segmentedPaths = tspSolver.findSegmentedPaths(points);

      /* segmentedPaths.printPaths(); */
      ArrayList<ArrayList<PlaceDTO>> schedule = segmentedPaths.paths();

      ArrayList<String> scheduleStr = new ArrayList<>();
      %>


      <!-- Main -->
      <div class="wrapper style1">

         <div class="container">
            <div class="row gtr-200">
               <div class="col-4 col-12-mobile" id="sidebar">
                  <hr class="first" />
                  <section>
                     <header>
                        <h3 id="sch_makelist1">
                           <a href="#">������ ����</a>
                        </h3>
                     </header>
                     <!--  <form action="/saveSchedule">
                            -->
                     <script type="text/javascript">
                           <%-- var positionArrArr = new Array(new Array());
                           var positionArr = new Array();
                           <%for(int i=0;i<schedule.size();i++) {%>
                                 <%for(int j=0;j<schedule.get(i).size();j++) {%>
                                    positionArrArr[<%=i%>].push("<%=schedule.get(i).get(j).getPlace_name()%>");
                                    positionArrArr[<%=i%>][<%=j%>] = "<%=schedule.get(i).get(j).getPlace_name()%>";
                                  <%}%>
                           <%}%> --%>
                          
                           </script>

                     <%
                     for (int j = 0; j < schedule.size(); j++) {
                        scheduleStr = new ArrayList<>();
                        placeStr = "";

                        for (int i = 0; i < schedule.get(j).size(); i++) {
                           placeStr += schedule.get(j).get(i).getPlace_name() + "///";
                        }
                     %>

                     <%--  <a href="#" onclick="CreateSchedule(<%=j%>)"> --%>
                     <div id="sch_makelist">
                        <input type="checkbox" name="cb" class="checkbox"
                           id="checkbox<%=j%>" value="<%=placeStr%>" />
                        <%
                        for (int i = 0; i < schedule.get(j).size(); i++) {
                           scheduleStr.add(schedule.get(j).get(i).getPlace_name());
                        %>
                        <span>&nbsp; <%=schedule.get(j).get(i).getPlace_name()%>&nbsp;
                        </span>
                        <%
                        }
                        %>


                     </div>
                     <!-- </a> -->



                     <%
                     }
                     %>


                     <%--                               <%
                                 for(PlaceDTO dto : daoArr){
                                   out.println("<span>" + "<img width='30%' height='20%'  src = \""+dto.getPlace_img()+"\">" + "</span>");
                                 }
                              %> --%>

                     <footer id="submitButton_footer">
                        <button onclick="submitForm()" id="submitButton" class="button">����
                           ����</button>

                     </footer>

                     <!-- </form> -->
                  </section>
                

               </div>
               <div class="col-8 col-12-mobile imp-mobile" id="content">
                  <article id="main">
                     
                     <div id="mapWrap">
                        <div id="map" style="width: 100%; height: 500px;"></div>
                     </div>
                     <script>   
                              var container = document.getElementById('map');
                              var options = {
                                      center: new kakao.maps.LatLng(33.3596213, 126.5311884),
                                      level: 10
                                  };
                              var map = new kakao.maps.Map(container, options);
                               
                              var markers = {};
                              var markerPlace; 
                              
                              /** üũ�ڽ� ���� ���� �� �߻� �Լ�*/
                              $(document).ready(function(){
                                       
                                  $(".checkbox").change(function(){
                                     var markers = new Array();
                                     var linePath = [];
                              
                                     $('#map').remove();
                                    let ttttt = "<div id='map' style='width:100%;height:500px;'></div>";
                                    $('#mapWrap').html(ttttt); 
                                    container = document.getElementById('map');
                                    options = {
                                            center: new kakao.maps.LatLng(33.3596213, 126.5311884),
                                            level: 10
                                        };
                                    map = new kakao.maps.Map(container, options);
                                     
                                      if($(".checkbox").is(":checked")){
                                          /* alert("üũ"); */
/*                                           console.log($("input:checkbox[name='cb']:checked").val());
                                          markerPlace = $("input:checkbox[name='cb']:checked").val(); */
                                          var pp = new Array();
                                          $('input:checkbox[name=cb]').each(function () {
                                             if($(this).is(":checked")==true){
                                                pp.push($(this).val());
                                             }
                                            
                                            });
                                          markerPlace = pp;
                                          for(var p = 0;p<pp.length;p++){
                                          $.ajax({
                                              url : "../placeToLatLng",
                                              type : "POST",
                                              dataType : "Json",
                                              data : {"markerPlace":pp[p]},
                                              success : function(result){
                                                 //console.log(result);
                                                 /* console.log(result); */
                                                 
                                                 linePath = [];
                                                 
                                                 for(var i =0; i<result.length;i++){
                                                 
                                                    addMarker(new kakao.maps.LatLng(parseFloat(result[i].place_latitude), parseFloat(result[i].place_longitude)));
                                                    linePath.push(new kakao.maps.LatLng(parseFloat(result[i].place_latitude), parseFloat(result[i].place_longitude)));
                                                 
                                                 
                                                 }
                                                 var polyline = new kakao.maps.Polyline({
                                                  path: linePath, // ���� �����ϴ� ��ǥ�迭 �Դϴ�
                                                  strokeWeight: 2, // ���� �β� �Դϴ�
                                                  strokeColor: 'blue', // ���� �����Դϴ�
                                                  strokeOpacity: 1, // ���� ������ �Դϴ� 1���� 0 ������ ���̸� 0�� �������� �����մϴ�
                                                  strokeStyle: 'solid' // ���� ��Ÿ���Դϴ�
                                              });
                                              
                                              // ������ ���� ǥ���մϴ� 
                                              
                                              polyline.setMap(map);
                                              function addMarker(position) {
                                                   
                                                  // ��Ŀ�� �����մϴ�
                                                 var marker = new kakao.maps.Marker({
                                                    position: position
                                                 });
                                                 //hideMarkers();
                                                 // ��Ŀ�� ���� ���� ǥ�õǵ��� �����մϴ�
                                                 marker.setMap(map);
                                                 // ������ ��Ŀ�� �迭�� �߰��մϴ�
                                                 markers.push(position);
                                                 
                                              }
                                              },
                                              error : function(e) {
                                                 console.log(e);
                                              }
                                           });
                                          }
                                      }
                                      else{
                                      }
                                  });
                              });

                              $(document).ready(function() {
                                  $(".routeCheckbox").change(function() {
                                      if ($(this).is(":checked")) {
                                          var selectedValue = $(this).val();
                                          /* console.log("Checked: " + selectedValue); */
                                      }
                                  });
                              });
                              function submitForm() {
                                 
                                 var checkedCheckboxes = $('input:checkbox[name=cb]:checked');
                                   
                                   if (checkedCheckboxes.length === 0) {
                                       alert("������ �����ϱ� ���� �ּ��� �ϳ� �̻��� üũ�ڽ��� �������ּ���.");
                                       return; // �� ���� ����
                                   }
                                    // form ��� ����
                                    var form = document.createElement("form");
                                    form.setAttribute("method", "post");
                                    form.setAttribute("action", "../saveSchedule");
                                    var placeStr = new Array();   
                                    // �迭 ���� ������ input ��ҷ� �߰�
                                    $('input:checkbox[name=cb]').each(function () {
                                        if($(this).is(":checked")==true){
                                           placeStr.push($(this).val());
                                           //console.log($(this).val());
                                        }
                                    });
                                    for(var i = 0;i<placeStr.length;i++){
                                        var input = document.createElement("input");
                                        input.setAttribute("type", "hidden");
                                        input.setAttribute("name", "place");
                                        input.setAttribute("value", placeStr[i]);
                                        form.appendChild(input);
                                    }
                               
                                    // form�� body�� �߰��ϰ� ����
                                    document.body.appendChild(form);
                                    form.submit();
                                    
                                }
                              

                           </script>

                  </article>
               </div>
            </div>
            <hr />

         </div>

      </div>

      <!-- Footer -->
      <div id="footer">
         <div class="container">
            <div class="row"></div>
            <hr />
            <div class="row">
               <div class="col-12">

                  <!-- Contact -->
                  <section class="contact">
                     <header>
                        <h3>���� ���� �����ڰ�</h3>
                     </header>
                     <p>�����һ��</p>
                     <ul class="icons">
                        <li><a href="#" class="icon brands fa-twitter"><span
                              class="label">Twitter</span></a></li>
                        <li><a href="#" class="icon brands fa-facebook-f"><span
                              class="label">Facebook</span></a></li>
                        <li><a href="#" class="icon brands fa-instagram"><span
                              class="label">Instagram</span></a></li>
                        <li><a href="#" class="icon brands fa-pinterest"><span
                              class="label">Pinterest</span></a></li>
                        <li><a href="#" class="icon brands fa-dribbble"><span
                              class="label">Dribbble</span></a></li>
                        <li><a href="#" class="icon brands fa-linkedin-in"><span
                              class="label">Linkedin</span></a></li>
                     </ul>
                  </section>

                  <!-- Copyright -->
                  <div class="copyright">
                     <ul class="menu">
                        <li>&copy; Untitled. All rights reserved.</li>
                        <li>Design: <a href="http://html5up.net">HTML5 UP</a></li>
                     </ul>
                  </div>

               </div>

            </div>
         </div>
      </div>

   </div>

   <!-- Scripts -->

   <script type="text/javascript"
      src="//dapi.kakao.com/v2/maps/sdk.js?appkey=17ef75805e870442ce556e97240445b9"></script>
   <script src="assets/js/jquery.min.js"></script>
   <script src="assets/js/schedule.js"></script>
   <script src="assets/js/jquery.dropotron.min.js"></script>
   <script src="assets/js/jquery.scrolly.min.js"></script>
   <script src="assets/js/jquery.scrollex.min.js"></script>
   <script src="assets/js/browser.min.js"></script>
   <script src="assets/js/breakpoints.min.js"></script>
   <script src="assets/js/util.js"></script>
   <script src="assets/js/main.js"></script>

</body>
</html>