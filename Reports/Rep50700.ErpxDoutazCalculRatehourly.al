report 50700 "Erpx Doutaz Calcul Rate hourly"
{    
    Caption = 'Doutaz Calcul Rate hourly';    
    ProcessingOnly = true;
    dataset
    {
        dataitem(SwSEmployee; "SwS Employee")
        {
            RequestFilterFields = "Employee No.";
            trigger OnPreDataItem()
            begin
                RatehoursHeader.DeleteAll();
            end;

            trigger OnAfterGetRecord()
            begin
                RatehoursHeader.Init();
                RatehoursHeader.Validate("Employee No.", SwSEmployee."Employee No.");
                RatehoursHeader.Insert();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        RatehoursHeader: Record "Erpx Doutaz Rate hours Header";
}
