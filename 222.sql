			SELECT                                                               --id=${v.distStoreId}&distId=${v.corprationId}"
            a.STOREID factStoreId --���ҵ���id
            ,a.COORPRATIONID  factId --������ҵid
            ,c.FACBRANDID brandId--Ʒ��id
            ,d.STOREID distStoreId --�����̵���id
            ,d.STORENAME distStoreName --�����̵�������
            ,d.COORPRATIONID corprationId --��������ҵid
            ,e.linkMan distName --��ϵ��
            ,e.MOBILEPHONE distTelephone --��ϵ�绰
            ,(SELECT count(1) FROM store.T_STORE m1 LEFT JOIN goods.t_goods_sku m2 ON m1.storeid = m2.STOREID
            inner join (select GOODSSKUID, MAX(SnapshotNO) SnapshotNO from goods.T_GOODS_SKU GROUP BY GOODSSKUID) maxsku
                on m2.GOODSSKUID = maxsku.GOODSSKUID and m2.SnapshotNO = maxsku.SnapshotNO
            INNER JOIN store.T_Store_AuthrizedGoods m3 ON m2.goodsskuid = m3.skugoodsid WHERE userid = d.COORPRATIONID and m2.brandid = c.FACBRANDID) distGoodsCount-- �����̴���˳�����Ʒ����
            ,d.STORESCORE distStoreScore--�����̵�������
            ,auth.channelopestatus distStoreStatus--�����̵������״̬
            ,e.CITYAREAID CITYID
            ,f.enterpriseName DISTSTATION --�����̷���վ����
            --,f.DISTRICTAREAID areaId--���ڵ���
            --,f.ProvinceAreaID provinceId--����ʡid
            --,f.CityAreaID cityId  --������
            ,d.storeType --��������
            ,bill.id billId --����id
            ,rel.billcycle --��������
            ,bill.billname --���㷽ʽ
            ,c.enterid  --��פid
            ,c.createtime
            FROM store.T_STORE a --���ҵ���
            inner JOIN store.T_Store_RecruitMerchantEnter c ON c.facbrandid = a.brandid
            AND c.PROCESSSTATUS = 2 AND c.APPROVALSTATUS = 0 AND c.DELETIONSTATUS = 0 --��������������Ч������
            inner JOIN store.t_store d ON c.STOREID = d.STOREID  AND d.STORESTATUS = 0 --AND d.SIGNSTATUS = 0 AND d.APPROVALSTATUS = 0 --�����̵�������
            left JOIN users.T_USER_CORPORATEUSER e ON d.COORPRATIONID = e.USERID -- ��������ҵ����
            left JOIN users.T_USER_CORPORATEUSER f ON d.ServiceStationID = f.USERID --�����̷���վ����
            -- ������Ȩ�����̵��̱�
          left join Store.T_Store_AuthrizedOperation
          auth on
          auth.FactoryStoreID=a.Storeid and auth.StoreID=d.StoreID
          left join store.t_store_recruit_billing_rel rel on c.enterid = rel.inviteorapplyid and rel.isclosed = 0
             left join store.t_store_recruit_billing bill on bill.id = rel.billid and bill.deletionstatus = 0
            WHERE a.APPROVALSTATUS = 0
            
   --          select * from goods.T_Goods_CategoryRel
   
   
   
         <if test="categoryType != null and categoryType == 1">
            <choose>
            <when test="category3 != null and category3 != ''">
              <![CDATA[AND cate.CATEGORYID = #{category3}]]>
            </when>
            <otherwise>
              <choose>
                <when test="category2 != null and category2 != ''">
                  <![CDATA[AND cate.CATEGORYID in (select categoryid from category.t_category start with categoryid = #{category2} connect by prior  categoryid = parentcategoryid)]]>
                </when>
                <otherwise>
                  <if test="category1 != null and category1 !=''" >
                     <![CDATA[AND cate.CATEGORYID in (select categoryid from category.t_category start with categoryid =  #{category1} connect by prior  categoryid = parentcategoryid)]]>
                  </if>
                </otherwise>
              </choose>
            </otherwise>
          </choose>
        </if>
        <if test="categoryType != null and categoryType == 2">
              <choose>
                <when test="category2 != null and category2 != ''">
                  <![CDATA[AND cate.CATEGORYID = #{category2}]]>
                </when>
                <otherwise>
                  <if test="category1 != null and category1 !=''" >
                     <![CDATA[AND cate.CATEGORYID in ((select storecategoryid from store.t_store_category  t  start with storecategoryid = #{category1} connect by prior  storecategoryid = parentcategoryid))]]>
                  </if>
                </otherwise>
              </choose>
        </if>

            
