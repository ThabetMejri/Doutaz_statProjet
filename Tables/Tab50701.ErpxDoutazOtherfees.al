table 50701 "ErpxDoutaz Other fees"
{
    Caption = 'Other fees';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; "Amount HT"; Decimal)
        {
            Caption = 'Amount HT';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "Amount Include VAT" := "Amount HT" * 1.077;
            end;
        }
        field(4; "Amount Include VAT"; Decimal)
        {
            Caption = 'Amount Include VAT';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "Amount HT" := "Amount Include VAT" / 1.077;
            end;
        }
        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(6; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Document No.", "Document Type", "Line No.")
        {
            Clustered = true;
        }
    }
    procedure GetNextLineNo(OtherFeesSource: Record "ErpxDoutaz Other fees"; BelowxRec: Boolean): Integer
    var
        OtherFees: Record "ErpxDoutaz Other fees";
        LowLineNo: Integer;
        HighLineNo: Integer;
        NextLineNo: Integer;
        LineStep: Integer;
    begin
        LowLineNo := 0;
        HighLineNo := 0;
        NextLineNo := 0;
        LineStep := 10000;
        OtherFees.SETRANGE("Document Type", rec."Document Type");
        OtherFees.SETRANGE("Document No.", rec."Document No.");
        IF OtherFees.FindLast() THEN
            IF NOT OtherFees.GET(OtherFeesSource."Document Type", OtherFeesSource."Document No.", OtherFeesSource."Line No.") THEN
                NextLineNo := OtherFees."Line No." + LineStep
            ELSE
                IF BelowxRec THEN BEGIN
                    OtherFees.FINDLAST;
                    NextLineNo := OtherFees."Line No." + LineStep;
                END ELSE
                    IF OtherFees.NEXT(-1) = 0 THEN BEGIN
                        LowLineNo := 0;
                        HighLineNo := OtherFeesSource."Line No.";
                    END ELSE BEGIN
                        OtherFees := OtherFeesSource;
                        OtherFees.NEXT(-1);
                        LowLineNo := OtherFees."Line No.";
                        HighLineNo := OtherFeesSource."Line No.";
                    END
        ELSE
            NextLineNo := LineStep;

        IF NextLineNo = 0 THEN
            NextLineNo := ROUND((LowLineNo + HighLineNo) / 2, 1, '<');

        IF OtherFees.GET(rec."Document Type", rec."Document No.", NextLineNo) THEN
            EXIT(0);
        EXIT(NextLineNo);
    end;


}
