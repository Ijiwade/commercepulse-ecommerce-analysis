{
    "version": 3,
    "inquiries": [
        {
            "id": "rMv_P151C8zw48C0u1V6U",
            "query": "-- monthly revenue trend \nSELECT\n\tSUBSTR(o.order_date,1,7) AS month,\n\tROUND(COALESCE(SUM(\n    COALESCE(oi.quantity,0)*\n    COALESCE(p.unit_price,0)* \n    (1 - COALESCE(oi.discount_pct,0))\n    ),0),2) AS monthly_revenue\nFROM orders o \nLEFT JOIN order_items oi \n\tON o.order_id = oi.order_id\nLEFT JOIN products p\n\tON p.product_id = oi.product_id\nGROUP BY month\nORDER BY month;",
            "viewType": "chart",
            "viewOptions": {
                "data": [],
                "layout": {
                    "autosize": true,
                    "xaxis": {
                        "range": [
                            -1,
                            6
                        ],
                        "autorange": true
                    },
                    "yaxis": {
                        "range": [
                            -1,
                            4
                        ],
                        "autorange": true
                    }
                },
                "frames": []
            },
            "name": "Monthly Revenue Trend",
            "updatedAt": "2026-03-06T19:46:54.871Z",
            "createdAt": "2026-03-06T19:40:10.123Z"
        }
    ]
}