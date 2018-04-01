package cn.slkj.jzlj.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.github.miemiedev.mybatis.paginator.domain.PageBounds;

import cn.slkj.jzlj.model.Qyz;

public interface QyzService {

	List<Qyz> getAll(HashMap<String, Object> map, PageBounds pageBounds);

	int save(Qyz sfdj);

	int feeOK(HashMap<String, Object> hashMap);

	int handle(HashMap<String, Object> hashMap);

	int zyzhz(HashMap<String, Object> hashMap);

	Qyz selectOne(HashMap<String, Object> map);
	
	List<Map<String, String>> getCountType();
}
