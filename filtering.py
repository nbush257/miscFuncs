import scipy.signal as signal
import numpy as np
import neo
import neoUtils
def bwfilt(sig,sr,low,high,N=8):
    if np.any(np.isnan(sig)):
        raise ValueError('Input to bwfilt has NaNs')

    ffo = low/(float(sr)/2)
    ff1 = high/(float(sr)/2)
    Wn = [ffo,ff1]
    btype = 'bandpass'
    if ffo <= 0:
        Wn = Wn[1]
        btype = 'low'
    elif ff1 >= 1:
        Wn = Wn[0]
        btype = 'high'

    b,a = signal.butter(N,Wn,btype=btype)

    return(signal.filtfilt(b,a,sig,axis=0))



def nan_filt(sig,sr,low,high,C,N=8):
    '''
    filter only during the contact portions. 
    
    :param sig: 
    :param sr: 
    :param low: 
    :param high: 
    :param C:   can be passed as a Cboolean or a Nx2 matrix of start times and durations
    :param N: 
    :return: 
    '''
    if True:
        raise Exception('not complete')
    if type(C) is np.array:
        starts,stops = neoUtils.Cbool_to_cc(C)
        durs = stops-starts
    elif type(C) is np.ndarray and C.ndim==2:
        starts = C[:,0]
        durs = C[:,1]

    sig_out = np.empty_like(sig)
    sig_out[:] = np.nan
    for start,dur in zip(starts,durs):
        sigin = sig[start-1:start+dur,:]
        if sigin.shape[0] < (3*N-1):
            sig_out[start-1:start+dur,:] = sigin
        else:
            x = bwfilt(sigin,sr,low,high,N)
            sig_out[start-1:start+dur,:] = x