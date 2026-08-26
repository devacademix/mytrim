import { TestBed, async, inject } from '@angular/core/testing';

import { AwaitLeaveGuard } from './leaved.guard';

describe('AwaitLeaveGuard', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [AwaitLeaveGuard]
    });
  });

  it('should ...', inject([AwaitLeaveGuard], (guard: AwaitLeaveGuard) => {
    expect(guard).toBeTruthy();
  }));
});
