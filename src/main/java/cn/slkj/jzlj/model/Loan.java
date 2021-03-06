package cn.slkj.jzlj.model;

public class Loan {

	private String id;//uid
	private String carName;//车牌号
	private String gcId;
	private String gcName;//工程名称
	private String jdTime;//借调时间
	private String managers;//操作人
	private String groupId;//分组ID
	private String groupName;//分组名称
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getCarName() {
		return carName;
	}
	public void setCarName(String carName) {
		this.carName = carName;
	}
	public String getGcName() {
		return gcName;
	}
	public void setGcName(String gcName) {
		this.gcName = gcName;
	}
	public String getJdTime() {
		return jdTime;
	}
	public void setJdTime(String jdTime) {
		this.jdTime = jdTime;
	}

	public String getManagers() {
		return managers;
	}

	public void setManagers(String managers) {
		this.managers = managers;
	}

	public String getGcId() {
		return gcId;
	}
	public void setGcId(String gcId) {
		this.gcId = gcId;
	}
	public String getGroupId() {
		return groupId;
	}
	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}
	public String getGroupName() {
		return groupName;
	}
	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}
	@Override
	public String toString() {
		return "Loan [id=" + id + ", carName=" + carName + ", gcName=" + gcName + ", jdTime=" + jdTime + ", managers=" + managers + "]";
	}
	
}
