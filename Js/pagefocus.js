// JScript 文件
//焦点的位置的背景颜色改变
function bill_item_focus_bg(obj) {
	obj.style.backgroundColor="#dfe7f7";
	obj.style.color="blue";
}
function bill_item_nofocus_bg(obj) {
	obj.style.backgroundColor="#f8fcff";
	obj.style.color="#000000";
}
function selectRow(row_index, currentTable)
                { 
		      for (i=1;i<currentTable.rows.length;i++) 
	             {
			      if (row_index==i) 
				     currentTable.rows.item(i).className="x_sub_table_row_selected";
			       else 
				     currentTable.rows.item(i).className="x_sub_table_row_unselected";
		            }
              }