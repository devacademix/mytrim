import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AwaitPaymentsProductComponent } from './await-payments-product.component';

describe('AwaitPaymentsProductComponent', () => {
  let component: AwaitPaymentsProductComponent;
  let fixture: ComponentFixture<AwaitPaymentsProductComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [AwaitPaymentsProductComponent]
    })
      .compileComponents();

    fixture = TestBed.createComponent(AwaitPaymentsProductComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
