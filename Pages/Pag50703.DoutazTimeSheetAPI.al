page 50703 "Doutaz TimeSheet API"
{
    APIGroup = 'TimeSheetAPI';
    APIPublisher = 'TimeSheetAPI';
    APIVersion = 'v2.0';
    Caption = 'DoutazTimeSheetAPI';
    DelayedInsert = true;
    EntityName = 'TimeSheet';
    EntitySetName = 'TimeSheet';
    PageType = API;
    SourceTable = "Erpx Doutaz TimeSheet Entries";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(entryNo; Rec."Entry No")
                {
                    Caption = 'Entry No';
                }
                field(resourceNo; Rec."Resource No.")
                {
                    Caption = 'Resource No.';
                }
                field(jobNo; Rec."Job No.")
                {
                    Caption = 'Job No.';
                }
                field("date"; Rec."Date")
                {
                    Caption = 'Date';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
            }
        }
    }
}
