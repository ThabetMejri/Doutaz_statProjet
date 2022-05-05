report 50702 "Erpx update Statistque"
{
    ApplicationArea = All;
    Caption = 'Erpx Update Job/Sales Order Statistques';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Integer; "Integer")
        {
            trigger OnPreDataItem()
            begin
                SetRange(Number, 1);
            end;

            trigger OnAfterGetRecord()
            begin
                //Update Sales Header
                SalesHeader.Reset();
                SalesHeader.SetFilter("ErpX Job No.", '<>%1', '');
                if SalesHeader.FindFirst() then
                    repeat
                        SalesHeader.CalculSalesHeader(SalesHeader);
                    until SalesHeader.Next() = 0;
                //Update Job
                if Job.FindFirst() then
                    repeat
                        Job.CalcSalesHeader(Job."No.");
                        Job.calcJob(Job."No.");
                    until Job.Next() = 0;
            end;
        }
    }

    var
        SalesHeader: Record "Sales Header";
        Job: Record Job;

}
